class ErrorMessageTemplate < Hanami::Entity

  def self.errors(messages)
    {
      "errors":{
        "body": messages
      }
    }.to_json
  end

end
