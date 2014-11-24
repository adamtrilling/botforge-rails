module Fishbulb::Concerns::Finders
  extend ActiveSupport::Concern

  included do

  end

  module ClassMethods
    def find_by(params = {})
      raise ArgumentError if params.keys.size < 1

      results = redis.smembers("#{model_key}:all")
      params.each do |k, v|
        results = results & _find_ids_by_field(k, v)
      end
      results.collect do |result_id|
        find(result_id)
      end
    end

    def find_by_any(params = {})
      raise ArgumentError if params.keys.size < 1

      params.collect do |k, v|
        _find_ids_by_field(k, v)
      end.flatten.uniq.collect do |result_id|
        find(result_id)
      end
    end

    protected
    def _find_ids_by_field(search_key, search_value)
      if (has_index?(search_key))
        if (has_unique_index?(search_key))
          result = redis.hget("#{model_key}:indexes:#{search_key}", search_value)
          if (result)
            [result]
          else
            []
          end
        else
          score = redis.hget("#{model_key}:indexes:#{search_key}:scores", search_value)
          redis.zrangebyscore("#{model_key}:indexes:#{search_key}:map", score, score)
        end
      else
        raise Fishbulb::UnindexedSearch
      end
    end
  end
end