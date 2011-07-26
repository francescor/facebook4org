class OrganisationPostsController < ApplicationController
  # GET /organisation_posts
  # GET /organisation_posts.xml
  layout 'main'

  def index
    if @current_user.is_admin
      @organisation_posts = OrganisationPost.all
      return
    end
    @organisation_posts = @current_user.organisation_posts # IndividualPost.find_all_by_user_id(@current_user)
    if @organisation_posts.size == 0
      redirect_to(new_organisation_post_path)
    else
      respond_to do |format|
        format.fbml # index.html.erb
      end
    end   
  end
  # GET /organisation_posts/1
  # GET /organisation_posts/1.xml
  def show
    #@organisation_post = OrganisationPost.find(params[:id])
    @organisation_post = OrganisationPost.first(:conditions=> {:id => params[:id]})
    if @organisation_post.nil?
      flash[:notice] = 'Oops. The offer you are searching for has been removed.'
      redirect_to search_organisations_url(:template => 'basic', :output => 'list')
    else
      @url_for_iframe = FACEBOOKER['callback_url'] + "/iframe/iframe_organisation_post_map?"+
                                   "organisation_post_id=#{@organisation_post.id}"
      respond_to do |format|
        format.fbml # show.html.erb
      end
    end
  end

  # GET /organisation_posts/new
  # GET /organisation_posts/new.xml
  def new
    @organisation_post = OrganisationPost.new

    respond_to do |format|
      format.fbml # new.html.erb
    end
  end

  # GET /organisation_posts/1/edit
  def edit
    @organisation_post = OrganisationPost.find(params[:id])
    if @current_user.is_admin || (@current_user.organisation == @organisation_post.organisation) 
      # show edit view
    else
      # not allowed
      redirect_to :action => :show, :id => params[:id]
    end
  end

  # POST /organisation_posts
  # POST /organisation_posts.xml
  def create
    #@organisation_post = OrganisationPost.new(params[:organisation_post])
    @organisation_post = @current_user.organisation_posts.build(params[:organisation_post])
    respond_to do |format|
      if @organisation_post.save
        flash[:notice] = 'Offer was successfully created.'
        # add notification
        notify_new_organisation_post(@organisation_post)
        format.fbml { redirect_to(organisation_posts_url) }
      else
        format.fbml { render :action => "new" }
      end
    end
  end

  # PUT /organisation_posts/1
  # PUT /organisation_posts/1.xml
  def update
    @organisation_post = OrganisationPost.find(params[:id])

    respond_to do |format|
      if @organisation_post.update_attributes(params[:organisation_post])
        flash[:notice] = 'Offer was successfully updated.'
        #format.fbml { redirect_to(@organisation_post) }
        format.fbml { redirect_to(organisation_posts_url) }
      else
        format.fbml { render :action => "edit" }
      end
    end
  end

  # DELETE /organisation_posts/1
  # DELETE /organisation_posts/1.xml
  def destroy
    @organisation_post = OrganisationPost.find(params[:id])
    organisation = @organisation_post.organisation
    if @current_user.is_admin || (@current_user.organisation == @organisation_post.organisation)
      @organisation_post.destroy
      flash[:notice] = 'Offer removed.'
    else
      redirect_to :controller => :main
    end
    respond_to do |format|
      format.fbml { redirect_to organisation }
    end
  end
end
