class InvitationsController < ApplicationController

  layout 'main'

  def index
    redirect_to home_url
  end

  def new
  end

  def create
    @sent_to_ids = params[:ids]
    if @sent_to_ids.nil?
      flash[:notice] = 'Invitations have been sent.'
      redirect_to home_url
    end
  end


end
