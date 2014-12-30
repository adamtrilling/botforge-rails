class Bot < Player
  validates :url,
    presence: true,
    url: true

  def invite(match)
    response = conn.post do |req|
      req.headers['Content-Type'] = 'application/json'
      req.body = Hash[
        type: 'invite',
        match_id: match.id,
        game: match.type
      ].to_json
    end

    return response.status == 200
  end

  def conn
    @conn ||= Faraday.new(url: self.url)
  end
end