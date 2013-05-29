define ['jquery.xml2json'], 
(xml2json) ->
    class NetflixList extends Backbone.Marionette.Layout
        el: '.netflix-content'

        events:
            'click a.sort': 'handleClick'

        regions:
            'movieList': '.movie-list'

        initialize: ->
            @sorter = 'ranking'
            do @getMovieList

        handleClick: (event) ->
            @sorter = $(event.currentTarget).data('value')
            do @showMovies
            return false

        getMovieList: ->
            $.ajax
                url: 'http://dvd.netflix.com/Top100RSS',
                dataType: "xml",
                type: 'GET',
                success: (res) =>
                    xml = res.responseText
                    # Convert xml data from rssFeed to Json for ease of use
                    data = $.xml2json(xml)
                    # Create new Backbone model with the 
                    @model = new Backbone.Model data
                    _.defer => do @buildCollection


        buildCollection: ->
            # Grab the items inside channel for the MovieListView but save the model for this parent Layout
            @movies = @model.get('channel')['item']
            for item in @movies
                description = item.description
                # Removing due to Cross-domain issues.
                item.review = @getMovieReview JSON.stringify(item.title)
                image_url = description.match(/src="(.+?[\.jpg])"/)[1]
                # Give me the big images :)
                item.image_url = image_url.replace 'small', 'ghd'

            # Let's store the alphabetical list in memory
            @alphaMovies = _.sortBy @movies, (item) -> item.title
            do @showMovies

        getMovieReview: (title) ->
            $.ajax
                url: 'http://api.rottentomatoes.com/api/public/v1.0/movies.json'
                data: 
                    apikey: '5guu6wsykg55qawcjsp2y8tk'
                    q: title
                    page_limit: 1
                success: (res) =>
                    console.log res.movies[0]
                    return res.movies[0].ratings.audience_score

        showMovies: ->
            (@$ 'a.sort').removeClass 'active'
            (@$ "a.sort[data-value=#{@sorter}]").addClass 'active'
            # If the sorter is now title make sure to build the collection with the alphabetical list
            if @sorter is 'title'
                @collection = new Backbone.Collection @alphaMovies
            else
                @collection = new Backbone.Collection @movies

            # Now that we have a collection use Marionette's wicked awesome CollectionView
            @movieList.show  new MovieListView
                collection: @collection


    class MovieView extends Backbone.Marionette.ItemView
        template: _.template $('#movie-template').html()

    class MovieListView extends Backbone.Marionette.CollectionView
        itemView: MovieView
        itemViewOptions:
            className: 'movie'
    

    app = new NetflixList()


