// Generated by CoffeeScript 1.4.0
var __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

define([], function() {
  var GuideApp, app;
  GuideApp = (function(_super) {

    __extends(GuideApp, _super);

    function GuideApp() {
      return GuideApp.__super__.constructor.apply(this, arguments);
    }

    return GuideApp;

  })(Backbone.Marionette.Application);
  app = new GuideApp;
  return app;
});