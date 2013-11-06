class ApplicationController < ActionController::Base
  include SessionsHelper
  include EditSuggestionsHelper

  protect_from_forgery
end
