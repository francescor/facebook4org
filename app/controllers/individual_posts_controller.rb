class IndividualPostsController < ApplicationController
  # GET /individual_posts
  # GET /individual_posts.xml
  layout 'main'

  def index
    #@individual_posts = IndividualPost.all
    @individual_posts = @current_user.individual_posts # IndividualPost.find_all_by_user_id(@current_user)
    if @individual_posts.size == 0
      redirect_to(new_individual_post_path)
    else
      respond_to do |format|
        format.fbml # index.html.erb
        format.xml  { render :xml => @individual_posts }
      end
    end
  end

  # GET /individual_posts/1
  # GET /individual_posts/1.xml
  def show
    @individual_post = IndividualPost.find(params[:id])

    respond_to do |format|
      format.fbml # show.html.erb
      format.xml  { render :xml => @individual_post }
    end
  end

  # GET /individual_posts/new
  # GET /individual_posts/new.xml
  def new
    @individual_post = IndividualPost.new

    respond_to do |format|
      format.fbml # new.html.erb
      format.xml  { render :xml => @individual_post }
    end
  end

  # GET /individual_posts/1/edit
  def edit
    @individual_post = IndividualPost.find(params[:id])
  end

  # POST /individual_posts
  # POST /individual_posts.xml
  def create
    @individual_post = IndividualPost.new(params[:individual_post])

    respond_to do |format|
      if @individual_post.save
        flash[:notice] = 'IndividualPost was successfully created.'
        #format.fbml { redirect_to(@individual_post) }
        format.fbml { redirect_to(individual_posts_url) }
        format.xml  { render :xml => @individual_post, :status => :created, :location => @individual_post }
      else
        format.fbml { render :action => "new" }
        format.xml  { render :xml => @individual_post.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /individual_posts/1
  # PUT /individual_posts/1.xml
  def update
    @individual_post = IndividualPost.find(params[:id])

    respond_to do |format|
      if @individual_post.update_attributes(params[:individual_post])
        flash[:notice] = 'IndividualPost was successfully updated.'
        #format.fbml { redirect_to(@individual_post) }
        format.fbml { redirect_to(individual_posts_url) }
        format.xml  { head :ok }
      else
        format.fbml { render :action => "edit" }
        format.xml  { render :xml => @individual_post.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /individual_posts/1
  # DELETE /individual_posts/1.xml
  def destroy
    @individual_post = IndividualPost.find(params[:id])
    @individual_post.destroy

    respond_to do |format|
      format.fbml { redirect_to(individual_posts_url) }
      format.xml  { head :ok }
    end
  end
end
