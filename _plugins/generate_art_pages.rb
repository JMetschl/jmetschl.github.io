module Jekyll
  class ArtPageGenerator < Generator
    safe true
    priority :highest

    def generate(site)
      puts "Starte ArtPageGenerator..."
      generate_art_pages(site, "japanese")
    end

    # -------------------------
    # Zentrale Slug-Funktion
    # -------------------------
    def slugify(str)
      str.downcase
         .strip
         .gsub(/[ä]/, "ae")
         .gsub(/[ö]/, "oe")
         .gsub(/[ü]/, "ue")
         .gsub(/[ß]/, "ss")
         .gsub(/[^a-z0-9]+/, "-")
         .gsub(/^-+|-+$/, "")
    end

    def generate_art_pages(site, art_type)
      return if site.data[art_type].nil? || site.data[art_type].empty?

      site.data[art_type].each do |art|
        puts "Generiere Seite für #{art_type} #{art['name']}"

        images = find_art_images(site, site.static_files, art['name'], art_type)
        main_image = images.first || art['image']

        site.pages << ArtPage.new(site, site.source, art, art_type, main_image, images, method(:slugify))
      end
    end

    def find_art_images(site, static_files, art_name, art_type)
      
      slug = slugify(art_name)
      folder_path = "/assets/img/#{art_type}/#{slug}/".downcase

      puts "🔎 Suche Bilder für: #{art_name} (Slug: #{slug})"
      puts "📁 Exakter Ordner (case-insensitive): #{folder_path}"

      static_files
        .map { |file| file.path.sub(site.source, "") }
        .select do |relative|
          rel = relative.downcase

          normalized = rel.gsub(/[‐‑‒–—―]/, "-")

          match = normalized.start_with?(folder_path)
          puts "✔️ Match: #{relative}" if match
          match
        end
    end
  end

  class ArtPage < Page
    def initialize(site, base, art, type, main_image, images, slugify)
      @site = site
      @base = base

      @dir  = "#{type}/#{slugify.call(art['name'])}"
      @name = 'index.html'

      self.process(@name)
      self.read_yaml(File.join(base, '_layouts'), 'art.html')

      self.data['title'] = art['name']
      self.data['name'] = art['name']
      self.data['type'] = type
      self.data['image'] = main_image
      self.data['images'] = images
      self.data['description'] = art['description']
      self.data['artist'] = art['artist']
      self.data['timespan'] = art['timespan']
    end
  end
end
