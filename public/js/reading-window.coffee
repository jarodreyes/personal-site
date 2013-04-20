define ['window', 'jquery.xml2json'], 
(WindowView, xml2json) ->
    String.prototype.trunc = 
        (n) ->
            return @substr(0,n-1)+ (if @length > n then '...' else '')

    class ReadingWindow extends WindowView
        className:'reading-window'
        template: _.template $('#reading-template').html()
        el: '.reading'
        url: 'http://www.goodreads.com/review/list/5406984.xml?key=Nkya34MwrAyEZ7cnbMzqA&v=2&shelf=read'
        # secret: vJEOgLqaHHBf8J1lZxgHYwZ0TszZSJDNfQnULnKmLIQ
        additionalEvents:
            'click a.next': 'slideNext'
            'click a.prev': 'slidePrev'

        regions:
            books: '.book-list'

        ui:
            'window': '.window'

        initialize: ->
            @getReadingData()
            @scrollable = true
            super

        toggleWindow: (event) ->
            @books.show @booksCollectionView
            @ui.window.append _.template $('#scroll-controls').html()
            (@$ 'small').toggleClass 'invisible'
            super

        getReadingData: ->
            $.ajax
                url: @url,
                dataType: "xml",
                type: 'GET',
                success: (res) =>
                    xml = res.responseText
                    # This is the part xml2Json comes in.
                    data = $.xml2json(xml)
                    @model = new Backbone.Model data.reviews
                    @prepareData()

        prepareData: ->
            reviews = @model.get 'review'
            for review in reviews
                image = review.book.image_url
                image = image.replace /m\/(?=\d)/g, 'l/'
                review.book.image_url = image
                title = review.book.title
                title = title.trunc(25)
                review.book.title = title
            @bookList = new Backbone.Collection reviews
            @renderBooks()

        renderBooks: ->
            @booksCollectionView = new BooksCollectionView
                collection: @bookList
                className: 'inner-scroll'

    class BookView extends Backbone.Marionette.ItemView
        template: _.template $('#books-template').html()

    class BooksCollectionView extends Backbone.Marionette.CollectionView
        itemView: BookView
        itemViewOptions:
            className: 'book-preview card'
            tagName: 'li'

    return ReadingWindow