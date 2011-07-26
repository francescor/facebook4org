class OrganisationPostSpokenLanguagesController < ApplicationController
  # GET /organisation_post_spoken_languages
  # GET /organisation_post_spoken_languages.xml
  layout 'main'

  def index
    @organisation_post_spoken_languages = OrganisationPostSpokenLanguage.all

    respond_to do |format|
      format.fbml # index.html.erb
      format.xml  { render :xml => @organisation_post_spoken_languages }
    end
  end

  # GET /organisation_post_spoken_languages/1
  # GET /organisation_post_spoken_languages/1.xml
  def show
    @organisation_post_spoken_language = OrganisationPostSpokenLanguage.find(params[:id])

    respond_to do |format|
      format.fbml # show.html.erb
      format.xml  { render :xml => @organisation_post_spoken_language }
    end
  end

  # GET /organisation_post_spoken_languages/new
  # GET /organisation_post_spoken_languages/new.xml
  def new
    @organisation_post_spoken_language = OrganisationPostSpokenLanguage.new

    respond_to do |format|
      format.fbml # new.html.erb
      format.xml  { render :xml => @organisation_post_spoken_language }
    end
  end

  # GET /organisation_post_spoken_languages/1/edit
  def edit
    @organisation_post_spoken_language = OrganisationPostSpokenLanguage.find(params[:id])
  end

  # POST /organisation_post_spoken_languages
  # POST /organisation_post_spoken_languages.xml
  def create
    @organisation_post_spoken_language = OrganisationPostSpokenLanguage.new(params[:organisation_post_spoken_language])

    respond_to do |format|
      if @organisation_post_spoken_language.save
        flash[:notice] = 'OrganisationPostSpokenLanguage was successfully created.'
        format.fbml { redirect_to(@organisation_post_spoken_language) }
        format.xml  { render :xml => @organisation_post_spoken_language, :status => :created, :location => @organisation_post_spoken_language }
      else
        format.fbml { render :action => "new" }
        format.xml  { render :xml => @organisation_post_spoken_language.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /organisation_post_spoken_languages/1
  # PUT /organisation_post_spoken_languages/1.xml
  def update
    @organisation_post_spoken_language = OrganisationPostSpokenLanguage.find(params[:id])

    respond_to do |format|
      if @organisation_post_spoken_language.update_attributes(params[:organisation_post_spoken_language])
        flash[:notice] = 'OrganisationPostSpokenLanguage was successfully updated.'
        format.fbml { redirect_to(@organisation_post_spoken_language) }
        format.xml  { head :ok }
      else
        format.fbml { render :action => "edit" }
        format.xml  { render :xml => @organisation_post_spoken_language.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /organisation_post_spoken_languages/1
  # DELETE /organisation_post_spoken_languages/1.xml
  def destroy
    @organisation_post_spoken_language = OrganisationPostSpokenLanguage.find(params[:id])
    @organisation_post_spoken_language.destroy

    respond_to do |format|
      format.fbml { redirect_to(organisation_post_spoken_languages_url) }
      format.xml  { head :ok }
    end
  end
end
