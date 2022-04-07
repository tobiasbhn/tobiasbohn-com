class PagesController < ApplicationController
  # no cookies in frontend at all
  after_action -> { request.session_options[:skip] = true }
end
