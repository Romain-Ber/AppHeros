class ProfilesController < ApplicationController

  def edit

  end

  def show
    @profile = current_user
  end

end
