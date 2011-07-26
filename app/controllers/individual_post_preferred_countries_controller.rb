class IndividualPostPreferredCountriesController < ApplicationController
  # GET /individual_post_preferred_countries
  # GET /individual_post_preferred_countries.xml
  layout 'main'
  
  def index
    @individual_post_preferred_countries = IndividualPostPreferredCountry.all

    respond_to do |format|
      format.fbml # index.html.erb
      format.xml  { render :xml => @individual_post_preferred_countries }
    end
  end

  # GET /individual_post_preferred_countries/1
  # GET /individual_post_preferred_countries/1.xml
  def show
    @individual_post_preferred_country = IndividualPostPreferredCountry.find(params[:id])

    respond_to do |format|
      format.fbml # show.html.erb
      format.xml  { render :xml => @individual_post_preferred_country }
    end
  end

  # GET /individual_post_preferred_countries/new
  # GET /individual_post_preferred_countries/new.xml
  def new
    @individual_post_preferred_country = IndividualPostPreferredCountry.new

    respond_to do |format|
      format.fbml # new.html.erb
      format.xml  { render :xml => @individual_post_preferred_country }
    end
  end

  # GET /individual_post_preferred_countries/1/edit
  def edit
    @individual_post_preferred_country = IndividualPostPreferredCountry.find(params[:id])
  end

  # POST /individual_post_preferred_countries
  # POST /individual_post_preferred_countries.xml
  def create
    @individual_post_preferred_country = IndividualPostPreferredCountry.new(params[:individual_post_preferred_country])

    respond_to do |format|
      if @individual_post_preferred_country.save
        flash[:notice] = 'IndividualPostPreferredCountry was successfully created.'
        format.fbml { redirect_to(@individual_post_preferred_country) }
        format.xml  { render :xml => @individual_post_preferred_country, :status => :created, :location => @individual_post_preferred_country }
      else
        format.fbml { render :action => "new" }
        format.xml  { render :xml => @individual_post_preferred_country.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /individual_post_preferred_countries/1
  # PUT /individual_post_preferred_countries/1.xml
  def update
    @individual_post_preferred_country = IndividualPostPreferredCountry.find(params[:id])

    respond_to do |format|
      if @individual_post_preferred_country.update_attributes(params[:individual_post_preferred_country])
        flash[:notice] = 'IndividualPostPreferredCountry was successfully updated.'
        format.fbml { redirect_to(@individual_post_preferred_country) }
        format.xml  { head :ok }
      else
        format.fbml { render :action => "edit" }
        format.xml  { render :xml => @individual_post_preferred_country.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /individual_post_preferred_countries/1
  # DELETE /individual_post_preferred_countries/1.xml
  def destroy
    @individual_post_preferred_country = IndividualPostPreferredCountry.find(params[:id])
    @individual_post_preferred_country.destroy

    respond_to do |format|
      format.fbml { redirect_to(individual_post_preferred_countries_url) }
      format.xml  { head :ok }
    end
  end
end
