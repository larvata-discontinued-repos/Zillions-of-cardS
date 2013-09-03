// Generated by CoffeeScript 1.6.3
var FilterCards, Init, RenderCardInfo, RenderFilterOptions, RenderMain, ResetFilters, dbFiltered;

dbFiltered = void 0;

$(document).ready(function() {
  dbFiltered = dbMain;
  return Init();
});

RenderFilterOptions = function() {
  var cardColorList, cardCostList, cardIconList, cardPowerList, cardRaceList, cardRarityList, cardSetList, cardTagList, cardTypeList;
  cardTypeList = _.chain(dbMain).pluck("Type").uniq().compact().without("-").value();
  $(".filter-types").children().remove();
  _.each(cardTypeList, function(type) {
    return $(".filter-types").append("<option value='" + type + "'>" + type + "</option>");
  });
  if (cardTypeList.length < 1) {
    $(".filter-types").prop("disabled", true);
  } else {
    $(".filter-types").prepend("<option value=''>(All)</option>");
  }
  cardColorList = _.chain(dbMain).pluck("CardColor_Ch").uniq().compact().without("-").value();
  $(".filter-colors").children().remove();
  _.each(cardColorList, function(color) {
    return $(".filter-colors").append("<label class='btn btn-primary btn-xs'><input type='checkbox' value='" + color + "'>" + color + "</label>");
  });
  $(".filter-colors label").addClass("active");
  $(".filter-colors input").prop("checked", true);
  cardCostList = _.chain(dbMain).pluck("Cost").uniq().compact().without("-").value().sort();
  $(".filter-costs").children().remove();
  _.each(cardCostList, function(cost) {
    return $(".filter-costs").append("<option>" + cost + "</option>");
  });
  if (cardCostList.length < 1) {
    $(".filter-cost-method").prop("disabled", true);
  } else {
    $(".filter-costs").prepend("<option value=''>(全部费用)</option>");
  }
  cardPowerList = _.chain(dbMain).pluck("Power").uniq().compact().without("-").value().sort();
  $(".filter-powers").children().remove();
  _.each(cardPowerList, function(power) {
    return $(".filter-powers").append("<option>" + power + "</option>");
  });
  if (cardPowerList.length < 1) {
    $(".filter-power-method").prop("disabled", true);
  } else {
    $(".filter-powers").prepend("<option value=''>(全部力量)</option>");
  }
  cardIconList = _.chain(dbMain).pluck("Icon").uniq().compact().without("-").value();
  $(".filter-icons").children().remove();
  _.each(cardIconList, function(icon) {
    return $(".filter-icons").append("<option value='" + icon + "'>" + icon + "</option>");
  });
  if (cardIconList.length < 1) {
    $(".filter-icons").prop("disabled", true);
  } else {
    $(".filter-icons").prepend("<option value=''>(全部标记)</option>");
  }
  cardRaceList = _.chain(dbMain).pluck("Race").uniq().compact().without("-").value();
  $(".filter-races").children().remove();
  _.each(cardRaceList, function(race) {
    return $(".filter-races").append("<option value='" + race + "'>" + race + "</option>");
  });
  if (cardRaceList.length < 1) {
    $(".filter-races").prop("disabled", true);
  } else {
    $(".filter-races").prepend("<option value=''>(全部种族)</option>");
  }
  cardSetList = _.chain(dbMain).pluck("CardSet").uniq().compact().without("-").value();
  $(".filter-cardsets").children().remove();
  _.each(cardSetList, function(set) {
    return $(".filter-cardsets").append("<option value='" + set + "'>" + set + "</option>");
  });
  if (cardSetList.length < 1) {
    $(".filter-cardsets").prop("disabled", true);
  } else {
    $(".filter-cardsets").prepend("<option value=''>(全部卡包)</option>");
  }
  cardRarityList = _.chain(dbMain).pluck("Rarity").uniq().compact().without("-").value();
  $(".filter-rarities").children().remove();
  _.each(cardRarityList, function(rarity) {
    return $(".filter-rarities").append("<option value='" + rarity + "'>" + rarity + "</option>");
  });
  if (cardRarityList.length < 1) {
    $(".filter-rarities").prop("disabled", true);
  } else {
    $(".filter-rarities").prepend("<option value=''>(全部罕贵度)</option>");
  }
  cardTagList = _.chain(dbMain).pluck("Tag").uniq().compact().without("-").value();
  $(".filter-tags").children().remove();
  return _.each(cardTagList, function(tag) {
    return $(".filter-tags").append("<label class='btn btn-primary btn-xs'><input type='checkbox' value='" + tag + "'>" + tag + "</label>");
  });
};

Init = function() {
  RenderFilterOptions();
  $(".btn-reset").click(function() {
    return ResetFilters();
  });
  $(".filter-keyword").on({
    change: function() {
      return FilterCards();
    },
    keyup: function() {
      return FilterCards();
    }
  });
  FilterCards();
  $(".filter-types").change(function() {
    return FilterCards();
  });
  $(".filter-colors input[type=checkbox]").change(function() {
    return FilterCards();
  });
  $(".filter-icons").change(function() {
    return FilterCards();
  });
  $(".filter-races").change(function() {
    return FilterCards();
  });
  $(".filter-cardsets").change(function() {
    return FilterCards();
  });
  $(".filter-rarities").change(function() {
    return FilterCards();
  });
  $(".filter-tags input[type=checkbox]").change(function() {
    return FilterCards();
  });
  return $(".zx-card-tabs li").click(function() {
    var tabId;
    $(".zx-card-tabs li").removeClass("active");
    $(this).addClass("active");
    $(".zx-tab-pages div").hide();
    tabId = $(this).data("tab");
    $(".zx-tab-pages div[data-tab=" + tabId + "]").show();
  });
};

RenderMain = function(t) {
  var filter_result_container, i, _i, _ref;
  filter_result_container = $(".main-filter-result");
  filter_result_container.children().remove();
  for (i = _i = 0, _ref = dbFiltered.length; 0 <= _ref ? _i < _ref : _i > _ref; i = 0 <= _ref ? ++_i : --_i) {
    filter_result_container.append("<a data-id='" + i + "'><span>" + dbFiltered[i].CardName_Ch + "</span></a>");
  }
  RenderCardInfo(0);
  return $(".main-filter-result a").click(function() {
    return RenderCardInfo($(this).data("id"));
  });
};

RenderCardInfo = function(id) {
  var card_tags_container;
  $(".main-filter-result a.actived").removeClass("actived");
  $(".main-filter-result a[data-id=" + id + "]").addClass("actived");
  $(".card-summary-image").css("background-image", "url(images/card-img/" + dbFiltered[id].SerialNo + ".png)");
  $(".card-summary-illustrator").text(dbFiltered[id].Illustrator);
  card_tags_container = $(".card-detail-tags");
  card_tags_container.children().remove();
  card_tags_container.append("<span class='label label-default'>" + dbFiltered[id].CardColor_Ch + "</span>");
  card_tags_container.append("<span class='label label-default'>" + dbFiltered[id].SerialNo + "</span>");
  card_tags_container.append("<span class='label label-default'>" + dbFiltered[id].Rarity + "</span>");
  card_tags_container.append("<span class='label label-default'>" + dbFiltered[id].Race + "</span>");
  card_tags_container.append("<span class='label label-default'>" + dbFiltered[id].Type + "</span>");
  $(".card-detail-cardname-ch").text(dbFiltered[id].CardName_Ch);
  $(".card-detail-cardname-jp").text(dbFiltered[id].CardName_Jp);
  $(".card-detail-cost").text(dbFiltered[id].Cost);
  $(".card-detail-power").text(dbFiltered[id].Power);
  $(".card-detail-icon").text(dbFiltered[id].Icon);
  $(".card-detail-ability-ch").text(dbFiltered[id].Ability_Ch);
  $(".card-description textarea").text(dbFiltered[id].Description_Ch);
  $(".card-neta textarea").text(dbFiltered[id].Neta);
  return $(".card-ruling textarea").text(dbFiltered[id].Ruling);
};

ResetFilters = function() {
  $(".filter-keyword").val("");
  $(".filter-types option:first-child").select();
  $(".filter-colors label").addClass("active");
  $(".filter-colors input").prop("checked", true);
  $(".filter-cost-method option:first-child").prop("selected", true);
  $(".filter-costs option:first-child").prop("selected", true);
  $(".filter-powers option:first-child").prop("selected", true);
  $(".filter-power-method option:first-child").prop("selected", true);
  $(".filter-icons option:first-child").prop("selected", true);
  $(".filter-races option:first-child").prop("selected", true);
  $(".filter-cardsets option:first-child").prop("selected", true);
  $(".filter-rarities option:first-child").prop("selected", true);
  $(".filter-tags label").removeClass("active");
  $(".filter-tags input").prop("checked", false);
  return FilterCards();
};

FilterCards = function() {
  var cardset, color, icon, keyword, race, rarity, tags, type;
  dbFiltered = dbMain;
  keyword = $(".filter-keyword").val();
  type = $(".filter-types").val();
  color = _.pluck($(".filter-colors input:checked"), "value");
  icon = $(".filter-icons").val();
  race = $(".filter-races").val();
  cardset = $(".filter-cardsets").val();
  rarity = $(".filter-rarities").val();
  tags = _.pluck($(".filter-tags input:checked"), "value");
  if (keyword.length !== 0) {
    dbFiltered = _.filter(dbFiltered, function(obj) {
      if ((obj.CardName_Ch != null) && obj.CardName_Ch.search(keyword) !== -1) {
        return true;
      } else if ((obj.CardName_Jp != null) && obj.CardName_Jp.search(keyword) !== -1) {
        return true;
      } else if ((obj.Nickname != null) && obj.Nickname.search(keyword) !== -1) {
        return true;
      } else {
        return false;
      }
    });
  }
  if (type.length !== 0) {
    dbFiltered = _.filter(dbFiltered, function(obj) {
      if (obj.Type.search(type) !== -1) {
        return true;
      } else {
        return false;
      }
    });
  }
  if (color.length !== 0) {
    dbFiltered = _.filter(dbFiltered, function(obj) {
      return _.contains(color, obj.CardColor_Ch);
    });
  }
  if (icon.length !== 0) {
    dbFiltered = _.filter(dbFiltered, function(obj) {
      if (obj.Icon.search(icon) !== -1) {
        return true;
      } else {
        return false;
      }
    });
  }
  if (race.length !== 0) {
    dbFiltered = _.filter(dbFiltered, function(obj) {
      if (obj.Race.search(race) !== -1) {
        return true;
      } else {
        return false;
      }
    });
  }
  if (cardset.length !== 0) {
    dbFiltered = _.filter(dbFiltered, function(obj) {
      if (obj.CardSet.search(cardset) !== -1) {
        return true;
      } else {
        return false;
      }
    });
  }
  if (rarity.length !== 0) {
    dbFiltered = _.filter(dbFiltered, function(obj) {
      if (obj.Rarity.search(rarity) !== -1) {
        return true;
      } else {
        return false;
      }
    });
  }
  if (tags.length !== 0) {
    dbFiltered = _.filter(dbFiltered, function(obj) {
      return _.contains(tags, obj.Tag);
    });
  }
  RenderMain();
};
