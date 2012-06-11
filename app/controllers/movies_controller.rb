class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    #~ @selected_ratings = []
    
    unless params.has_key? :sort or params.has_key? :ratings
      params[:sort] = session[:sort]
      params[:ratings] = session[:ratings]
    end
    
    
    if params['ratings']
      #~ @selected_ratings = params['ratings'].keys 
      if params['ratings'].kind_of? Hash
        @selected_ratings = params['ratings'].keys
      else
        @selected_ratings = params['ratings']
      end
    else
      @selected_ratings = Movie.get_all_ratings
    end
    # --- debug ---
    puts "\n--- INDEX METHOD START ---"
    puts session.inspect
    puts params.inspect
    puts @selected_ratings.inspect
    # -------------
    
    @all_ratings = Movie.get_all_ratings
    @sort = params[:sort]
    
    if @sort == 'title'
      @movies = Movie.find(:all, :order => 'title')
      filter_ratings
    elsif @sort == 'release_date'
      @movies = Movie.find(:all, :order => 'release_date')
      filter_ratings
    else
      #~ @movies = Movie.all
      #~ @movies = Movie.where({ :rating => @selected_ratings }).all # works
      #~ @movies = Movie.find_all_by_rating(params[:ratings].keys) # works
      @movies = Movie.find_all_by_rating(@selected_ratings) # works
    end
    
    # saving current settings to session hash:
    session[:sort] = params[:sort]
    session[:ratings] = params[:ratings]

    puts "\n--- INDEX METHOD END ---"
  end
  
  def filter_ratings
    @movies = @movies.select do |m|
      @selected_ratings.include? m.rating
    end
  end
  
  
  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end
