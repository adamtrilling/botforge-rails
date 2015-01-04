class Bot < Player
  validates :url,
    presence: true,
    url: true

  def conn
    @conn ||= Faraday.new(url: self.url)
  end

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

  def request_move(match)
    response = conn.post do |req|
      req.headers['Content-Type'] = 'application/json'
      req.body = Hash[
        type: 'move',
        match_id: match.id,
        state: match.state,
        participants: match.participants
      ].to_json
    end

    if response.status == 200
      begin
        move = JSON.parse(response.body)['move']
        match.execute_move(move)

        return true
      rescue JSON::ParserError
        return true
      end
    else
      return false
    end
  end
end