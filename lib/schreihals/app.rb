module Schreihals
  class App < Sinatra::Base
    set :views, File.expand_path('../../views/', __FILE__)
    set :public_folder, File.expand_path('../../public/', __FILE__)

    use Schreihals::Static
    use Rack::ShowExceptions
    use Rack::Cache
    use Rack::Codehighlighter, :coderay, :markdown => true, :element => "pre>code", :pattern => /\A:::(\w+)\s*\n/

    helpers Schreihals::Helpers

    configure do
      set :blog_title, "My Schreihals Blog"
      set :blog_url, ""
      set :blog_description, ""
      set :author_name, "Author"
      set :disqus_name, nil
      set :google_analytics_id, nil
      set :gauges_id, nil
      set :read_more, "Read Complete Article"
      set :documents_store, :filesystem
      set :documents_source, './posts'
      set :documents_cache, nil
      set :twitter_id, nil
      set :footer, ""
    end

    def refresh_documents_now?
      !Post.documents.any?
    end

    def refresh_documents!
      case settings.documents_store
      when :filesystem
        Post.send(:include, DocumentMapper::FilesystemStore)
        Post.load_documents_from_filesystem(settings.documents_source)
      when :dropbox
        Post.send(:include, DocumentMapper::DropboxStore)
        Post.load_documents_from_dropbox(settings.documents_source, :cache => settings.documents_cache)
      else
        raise "Unknown documents store '#{settings.documents_store}'."
      end
    end

    before do
      refresh_documents! if refresh_documents_now?
      cache_control :public, :must_revalidate, :max_age => 60
    end

    get '/' do
      @posts = Post.order_by(:date => :desc)
      @posts = @posts.where(:status => 'published') if production?
      @posts = @posts.limit(10).all
      @show_description = true
      haml :index
    end

    get '/schreihals.css' do
      scss :schreihals
    end

    get '/atom.xml' do
      @posts = Post.where(:status => 'published').order_by(:date => :desc).limit(10).all
      xml = haml :atom, :layout => false

      doc = Nokogiri::XML(xml)

      doc.css("content img").each do |node|
        node['src'] = absolutionize(node['src'])
      end

      content_type 'application/xml+atom'
      doc.to_xml
    end

    get '/:year/:month/:day/:slug/?' do |year, month, day, slug|
      render_page(slug)
    end

    get '/:slug/?' do |slug|
      render_page(slug)
    end

    def render_page(slug)
      if @post = Post.where(:slug => slug).first
        haml :post
      else
        halt 404
      end
    end

    def absolutionize(url)
      if should_absolutionize?(url)
        "#{base_url}#{url}"
      else
        url
      end
    end

    def should_absolutionize?(url)
      url && url[0] == '/'
    end

    def base_url
      "#{env['rack.url_scheme']}://#{env['HTTP_HOST']}"
    end

    not_found do
      haml :"404"
    end
  end
end
