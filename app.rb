class App
  def call(env)
    response = Router.instance.handle(env)
    [response.status, response.headers, response.content]
  end
end
