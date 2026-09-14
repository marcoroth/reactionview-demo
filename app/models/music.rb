module Music
  ALBUMS = [
    { id: "warehouse-frequencies", title: "Warehouse Frequencies", artist: "Modular Grid", year: 2021 },
    { id: "acid-archive", title: "Acid Archive", artist: "303 Committee", year: 2019 },
    { id: "voltage-controlled", title: "Voltage Controlled", artist: "CV Gate", year: 2023 },
    { id: "rhine-pressure", title: "Rhine Pressure", artist: "Basel Basskommando", year: 2024 },
    { id: "sub-terrain", title: "Sub Terrain", artist: "Low End Bureau", year: 2020 },
    { id: "monotone", title: "Monotone", artist: "Grauzone Kollektiv", year: 2022 },
    { id: "afterhours", title: "Afterhours", artist: "Sunrise Denial", year: 2018 },
    { id: "sequenced", title: "Sequenced", artist: "16 Step Program", year: 2025 },
    { id: "peak-time", title: "Peak Time", artist: "Kessel Haus", year: 2016 },
    { id: "cold-storage", title: "Cold Storage", artist: "Kühlraum Vier", year: 2019 },
    { id: "dreiland", title: "Dreiland", artist: "Border Traffic", year: 2022 },
    { id: "tape-hiss", title: "Tape Hiss", artist: "Ferric Oxide", year: 2015 },
    { id: "night-bus", title: "Night Bus", artist: "Linie Elf", year: 2021 },
    { id: "supply-chain", title: "Supply Chain", artist: "Logistik", year: 2024 },
    { id: "white-label", title: "White Label", artist: "Untitled Artists", year: 2017 },
    { id: "control-room", title: "Control Room", artist: "Fader Union", year: 2025 }
  ].freeze

  TRACKS = {
    "warehouse-frequencies" => [ "Loading Dock", "Forklift Funk", "Pallet Shuffle", "Concrete Reverb", "Roller Door", "Last Shift" ],
    "acid-archive" => [ "Resonance Peak", "Squelch", "Slide and Accent", "Silver Box", "Battery Backup" ],
    "voltage-controlled" => [ "Patch Cable", "Sawtooth Sunrise", "Envelope Follower", "Ring Mod", "Feedback Path", "Ground Hum", "Power Down" ],
    "rhine-pressure" => [ "Hafenbecken", "Dreirosen Dub", "Fasnacht 909", "Kleinbasel Kick", "Rheinschwumm" ],
    "sub-terrain" => [ "Sub Level One", "Foundation", "Bedrock", "Seismic Load", "Emergency Exit" ],
    "monotone" => [ "Grey Loop", "Beige Noise", "Off White", "Anthracite", "Charcoal Fade" ],
    "afterhours" => [ "Doors at Four", "No Requests", "Strobe Fatigue", "Coat Check", "Blinds Down", "Tram Home" ],
    "sequenced" => [ "Step One", "Gate Length", "Swing Amount", "Ratchet", "Probability", "Reset Trigger" ],
    "peak-time" => [ "Queue Outside", "Cloakroom Rush", "Main Room", "Hands Up", "Rewind", "Encore Encore" ],
    "cold-storage" => [ "Frost Pattern", "Minus Eighteen", "Compressor Cycle", "Defrost", "Ice Sheet" ],
    "dreiland" => [ "Customs Check", "Tram Eight", "Weil am Rhein", "Saint-Louis", "Passport Techno", "Border Stone" ],
    "tape-hiss" => [ "Side A", "Dropout", "Wow and Flutter", "Splice", "Leader Tape", "Side B" ],
    "night-bus" => [ "Last Departure", "Empty Seats", "Window Fog", "Request Stop", "Depot" ],
    "supply-chain" => [ "Just In Time", "Container Stack", "Manifest", "Cross Dock", "Final Mile" ],
    "white-label" => [ "Untitled A1", "Untitled A2", "Untitled B1", "Promo Only", "Runout Groove" ],
    "control-room" => [ "Talkback", "Gain Staging", "Solo Bus", "Mute Group", "Fade Out", "Bounce Down" ]
  }.freeze

  def self.albums = ALBUMS

  def self.find(id)
    ALBUMS.find { |album| album[:id] == id }
  end

  def self.title(id) = find(id)&.fetch(:title).to_s
  def self.artist(id) = find(id)&.fetch(:artist).to_s
  def self.year(id) = find(id)&.fetch(:year).to_s

  def self.tracks(id)
    (TRACKS[id] || []).each_with_index.map { |title, position|
      { album: id, number: position + 1, title: title, duration: format("%d:%02d", 5 + (title.length % 4), (title.sum * 7) % 60) }
    }
  end

  def self.track_count(id) = (TRACKS[id] || []).size

  def self.cover_url(id)
    "https://picsum.photos/seed/#{id}/300/300"
  end

  def self.latest_releases
    ALBUMS.sort_by { |album| -album[:year] }.first(4)
  end

  def self.track_seconds(key)
    album, number = key.to_s.split(":")

    return 60 if number.nil?

    duration = tracks(album).dig(number.to_i - 1, :duration).to_s
    minutes, seconds = duration.split(":").map(&:to_i)

    ((minutes || 0) * 60) + (seconds || 0)
  end

  def self.row_action(entry, track, number)
    if track == entry[:album] && number == entry[:number]
      "track='' number=0 playing=false"
    else
      "track='#{entry[:album]}' number=#{entry[:number]} playing=true"
    end
  end

  def self.track_name(album, number)
    tracks(album).dig(number.to_i - 1, :title).to_s
  end

  def self.seconds(album, number)
    duration = tracks(album).dig(number.to_i - 1, :duration).to_s
    minutes, rest = duration.split(":").map(&:to_i)

    ((minutes || 0) * 60) + (rest || 0)
  end

  def self.track_title(key)
    album, number = key.to_s.split(":")

    return title(album) if number.nil?

    tracks(album).dig(number.to_i - 1, :title).to_s
  end
end
