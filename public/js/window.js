// Generated by CoffeeScript 1.4.0
var __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

define([], function() {
  var WindowView;
  return WindowView = (function(_super) {

    __extends(WindowView, _super);

    function WindowView() {
      return WindowView.__super__.constructor.apply(this, arguments);
    }

    WindowView.prototype.originalEvents = {
      'click': 'toggleWindow'
    };

    WindowView.prototype.pages = 5;

    WindowView.prototype.additionalEvents = {};

    WindowView.prototype.events = function() {
      return _.extend({}, this.originalEvents, this.additionalEvents);
    };

    WindowView.prototype.initialize = function() {
      this.render();
      return this.leftScroll = 0;
    };

    WindowView.prototype.setupSlider = function() {
      this.slideBox = this.$('.inner-scroll');
      this.windowWidth = (this.$('.card')).outerWidth(true);
      return this.maxScroll = this.windowWidth * this.pages;
    };

    WindowView.prototype.slideNext = function(e) {
      e.stopImmediatePropagation();
      if (this.leftScroll < this.maxScroll) {
        this.leftScroll += this.windowWidth;
      }
      this.slideBox.css('margin-left', -this.leftScroll);
      return false;
    };

    WindowView.prototype.slidePrev = function(e) {
      e.stopImmediatePropagation();
      if (this.leftScroll > 0) {
        this.leftScroll -= this.windowWidth;
      }
      this.slideBox.css('margin-left', -this.leftScroll);
      return false;
    };

    WindowView.prototype.toggleWindow = function(event) {
      (this.$('.window')).toggleClass('open');
      if (this.scrollable) {
        return this.setupSlider();
      }
    };

    return WindowView;

  })(Backbone.Marionette.Layout);
});