class UserSpokenLanguagesController < ApplicationController
  # GET /user_spoken_languages
  # GET /user_spoken_languages.xml
  layout 'main'

  def index
    @user_spoken_languages = UserSpokenLanguage.all

    respond_to do |format|
      format.fbml # index.html.erb
      format.xml  { render :xml => @user_spoken_languages }
    end
  end

  # GET /user_spoken_languages/1
  # GET /user_spoken_languages/1.xml
  def show
    @user_spoken_language = UserSpokenLanguage.find(params[:id])

    respond_to do |format|
      format.fbml # show.html.erb
      format.xml  { render :xml => @user_spoken_language }
    end
  end

  # GET /user_spoken_languages/new
  # GET /user_spoken_languages/new.xml
  def new
    @user_spoken_language = UserSpokenLanguage.new

    respond_to do |format|
      format.fbml # new.html.erb
      format.xml  { render :xml => @user_spoken_language }
    end
  end

  # GET /user_spoken_languages/1/edit
  def edit
    @user_spoken_language = UserSpokenLanguage.find(params[:id])
  end

  # POST /user_spoken_languages
  # POST /user_spoken_languages.xml
  def create
    @user_spoken_language = UserSpokenLanguage.new(params[:user_spoken_language])

    respond_to do |format|
      if @user_spoken_language.save
        flash[:notice] = 'UserSpokenLanguage was successfully created.'
        format.fbml { redirect_to(@user_spoken_language) }
        format.xml  { render :xml => @user_spoken_language, :status => :created, :location => @user_spoken_language }
      else
        format.fbml { render :action => "new" }
        format.xml  { render :xml => @user_spoken_language.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /user_spoken_languages/1
  # PUT /user_spoken_languages/1.xml
  def update
    @user_spoken_language = UserSpokenLanguage.find(params[:id])

    respond_to do |format|
      if @user_spoken_language.update_attributes(params[:user_spoken_language])
        flash[:notice] = 'UserSpokenLanguage was successfully updated.'
        format.fbml { redirect_to(@user_spoken_language) }
        format.xml  { head :ok }
      else
        format.fbml { render :action => "edit" }
        format.xml  { render :xml => @user_spoken_language.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /user_spoken_languages/1
  # DELETE /user_spoken_languages/1.xml
  def destroy
    @user_spoken_language = UserSpokenLanguage.find(params[:id])
    @user_spoken_language.destroy

    respond_to do |format|
      format.fbml { redirect_to(user_spoken_languages_url) }
      format.xml  { head :ok }
    end
  end
end
