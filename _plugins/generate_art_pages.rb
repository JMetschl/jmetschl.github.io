module Jekyll
  class ArtPageGenerator < Generator
    safe true
    priority :highest

    def generate(site)
      puts "Starte ArtPageGenerator..."

      generate_art_pages(site, "japanese")
    end

    def generate_art_pages(site, art_type)
      return if site.data[art_type].nil? || site.data[art_type].empty?

      site.data[art_type].each do |art|
        puts "Generiere Seite für #{art_type} #{art['name']}"

        # Finde alle passenden Bilder für das Tier
        images = find_art_images(site.static_files, art['name'], art_type)

        # Erstes Bild als Hauptbild setzen (falls vorhanden)
        main_image = images.first || art['image']

        # Erstelle die Seite
        site.pages << ArtPage.new(site, site.source, art, art_type, main_image, images)
      end
    end

    def find_art_images(static_files, art_name, art_type)
      folder_path = "/assets/img/#{art_type}/"  # Angepasster Pfad
      name_downcased = art_name.downcase.gsub(' ', '-')

      static_files
        .select { |file| file.path.include?(folder_path) && file.path.downcase.include?(name_downcased) }
        .map { |file| file.path.sub(/^.*?(\/assets\/img\/)/, '\1') }  # Nur den Teil ab /assets/ behalten
    end
  end

  class ArtPage < Page
    def initialize(site, base, art, type, main_image, images)
      @site = site
      @base = base

      @dir  = "#{type}/#{art['name'].downcase.strip.gsub(' ', '-').gsub(/[^\w-]/, '')}"
      @name = 'index.html'

      self.process(@name)
      self.read_yaml(File.join(base, '_layouts'), 'art.html')
      self.data['title'] = art['name']
      self.data['name'] = art['name']
      self.data['type'] = type 
      self.data['image'] = main_image
      self.data['images'] = images
    end
  end
end
