

dbFiltered = undefined
# dbMain = undefined
# $.get "db/abcout.json", (data) ->
#   dbMain = $.parseJSON(data)
#   dbFiltered = dbMain
#   Init()

$(document).ready ->
    dbFiltered = dbMain
    Init()

RenderFilterOptions = ->
    # 种类
    cardTypeList=_.chain(dbMain).pluck("Type").uniq().compact().without("-").value()
    $(".filter-types").children().remove()
    _.each cardTypeList ,(type)->
        $(".filter-types").append("<option value='#{type}'>#{type}</option>")
    if cardTypeList.length < 1
        $(".filter-types").prop("disabled",true) 
    else
        $(".filter-types").prepend("<option value=''>(All)</option>")

    # 颜色
    cardColorList=_.chain(dbMain).pluck("CardColor_Ch").uniq().compact().without("-").value()
    $(".filter-colors").children().remove()
    _.each cardColorList, (color)->
        $(".filter-colors").append("<label class='btn btn-primary btn-xs'><input type='checkbox' value='#{color}'>#{color}</label>")
    $(".filter-colors label").addClass("active")
    $(".filter-colors input").prop("checked",true)

    # 费用
    cardCostList=_.chain(dbMain).pluck("Cost").uniq().compact().without("-").value().sort()
    $(".filter-costs").children().remove()
    _.each cardCostList,(cost)->
        $(".filter-costs").append("<option>#{cost}</option>")
    $(".filter-cost-method").prop("disabled",true) if cardCostList.length < 1

    # 力量
    cardPowerList=_.chain(dbMain).pluck("Power").uniq().compact().without("-").value().sort()
    $(".filter-powers").children().remove()
    _.each cardPowerList,(power)->
        $(".filter-powers").append("<option>#{power}</option>")
    $(".filter-power-method").prop("disabled",true) if cardPowerList.length < 1

    # 标记
    cardIconList=_.chain(dbMain).pluck("Icon").uniq().compact().without("-").value()
    $(".filter-icons").children().remove()
    _.each cardIconList,(icon)->
        $(".filter-icons").append("<option value='#{icon}'>#{icon}</option>")
    if cardIconList.length < 1
        $(".filter-icons").prop("disabled",true) 
    else
        $(".filter-icons").prepend("<option value=''>(All)</option>")
    
    # 种族
    cardRaceList=_.chain(dbMain).pluck("Race").uniq().compact().without("-").value()
    $(".filter-races").children().remove()
    _.each cardRaceList,(race)->
        $(".filter-races").append("<option value='#{race}'>#{race}</option>")
    if cardRaceList.length < 1
        $(".filter-races").prop("disabled",true) 
    else
        $(".filter-races").prepend("<option value=''>(All)</option>")

    # 卡包
    cardSetList=_.chain(dbMain).pluck("CardSet").uniq().compact().without("-").value()
    $(".filter-cardsets").children().remove()
    _.each cardSetList,(set)->
        $(".filter-cardsets").append("<option value='#{set}'>#{set}</option>")
    if cardSetList.length < 1
        $(".filter-cardsets").prop("disabled",true) 
    else
        $(".filter-cardsets").prepend("<option value=''>(All)</option>")

    # 罕贵度
    cardRarityList=_.chain(dbMain).pluck("Rarity").uniq().compact().without("-").value()
    $(".filter-rarities").children().remove()
    _.each cardRarityList,(rarity)->
        $(".filter-rarities").append("<option value='#{rarity}'>#{rarity}</option>")
    if cardRarityList.length < 1
        $(".filter-rarities").prop("disabled",true) 
    else
        $(".filter-rarities").prepend("<option value=''>(All)</option>")

    # 效果分类
    cardTagList=_.chain(dbMain).pluck("Tag").uniq().compact().without("-").value()
    $(".filter-tags").children().remove()
    _.each cardTagList,(tag)->
        $(".filter-tags").append("<label class='btn btn-primary btn-xs'><input type='checkbox' value='#{tag}'>#{tag}</label>")
    # $(".filter-tags label").addClass("active")
    # $(".filter-tags input").prop("checked",true)

Init = () ->
    # redraw filter-options
    RenderFilterOptions()

    # bind event
    $(".btn-reset").click ->
        ResetFilters()

    $(".filter-keyword").on
        change:->
            FilterCards()
        keyup:->
            FilterCards()
    FilterCards()

    $(".filter-types").change ->
        FilterCards()

    $(".filter-colors input[type=checkbox]").change ->
        FilterCards()

    $(".filter-icons").change ->
        FilterCards()   
         
    $(".filter-races").change ->
        FilterCards()    

    $(".filter-cardsets").change ->
        FilterCards()  

    $(".filter-rarities").change ->
        FilterCards()   

    $(".filter-tags input[type=checkbox]").change ->
        FilterCards()

    $(".zx-card-tabs li").click ->
        $(".zx-card-tabs li").removeClass("active")
        $(@).addClass("active")
        $(".zx-tab-pages div").hide()
        tabId=$(@).data("tab")
        $(".zx-tab-pages div[data-tab=#{tabId}]").show()
        return


RenderMain = (t) ->
    
    # redraw filter-result
    filter_result_container=$(".main-filter-result")
    filter_result_container.children().remove()
    for i in [0...dbFiltered.length]
        filter_result_container.append("<a data-id='#{i}'><span>#{dbFiltered[i].CardName_Ch}</span></a>")
    RenderCardInfo(0);

    $(".main-filter-result a").click ->
        RenderCardInfo($(@).data("id"))

RenderCardInfo = (id)->
    $(".main-filter-result a.actived").removeClass("actived")
    $(".main-filter-result a[data-id=#{id}]").addClass("actived")
    # redraw card main details by card database id
    $(".card-summary-image").css("background-image","url(images/card-img/#{dbFiltered[id].SerialNo}.png)")
    $(".card-summary-illustrator").text(dbFiltered[id].Illustrator)
    card_tags_container=$(".card-detail-tags")
    card_tags_container.children().remove()
    card_tags_container.append("<span class='label label-default'>#{dbFiltered[id].CardColor_Ch}</span>")
    card_tags_container.append("<span class='label label-default'>#{dbFiltered[id].SerialNo}</span>")
    card_tags_container.append("<span class='label label-default'>#{dbFiltered[id].Rarity}</span>")
    card_tags_container.append("<span class='label label-default'>#{dbFiltered[id].Race}</span>")
    card_tags_container.append("<span class='label label-default'>#{dbFiltered[id].Type}</span>")
    $(".card-detail-cardname-ch").text(dbFiltered[id].CardName_Ch)
    $(".card-detail-cardname-jp").text(dbFiltered[id].CardName_Jp)
    $(".card-detail-cost").text(dbFiltered[id].Cost)
    $(".card-detail-power").text(dbFiltered[id].Power)
    $(".card-detail-icon").text(dbFiltered[id].Icon)
    $(".card-detail-ability-ch").text(dbFiltered[id].Ability_Ch)
    $(".card-description textarea").text(dbFiltered[id].Description_Ch)
    $(".card-neta textarea").text(dbFiltered[id].Neta)
    $(".card-ruling textarea").text(dbFiltered[id].Ruling)

ResetFilters = () ->
    $(".filter-keyword").val("")
    $(".filter-types option:first-child").select()
    $(".filter-colors label").addClass("active")
    $(".filter-colors input").prop("checked",true)
    $(".filter-cost-method option:first-child").prop("selected",true)
    $(".filter-power-method option:first-child").prop("selected",true)
    $(".filter-icons option:first-child").prop("selected",true)
    $(".filter-races option:first-child").prop("selected",true) 
    $(".filter-cardsets option:first-child").prop("selected",true)
    $(".filter-rarities option:first-child").prop("selected",true)
    $(".filter-tags label").removeClass("active")
    $(".filter-tags input").prop("checked",false)
    FilterCards()

FilterCards = () ->
    dbFiltered = dbMain
    keyword = $(".filter-keyword").val()
    type = $(".filter-types").val()    
    color = _.pluck($(".filter-colors input:checked"),"value")
    icon=$(".filter-icons").val()
    race=$(".filter-races").val()
    cardset=$(".filter-cardsets").val()
    rarity=$(".filter-rarities").val()
    tags=_.pluck($(".filter-tags input:checked"),"value")

    if keyword.length != 0
        dbFiltered = _.filter dbFiltered,(obj)->
            if  obj.CardName_Ch? and obj.CardName_Ch.search(keyword) != -1
                true
            else if obj.CardName_Jp? and obj.CardName_Jp.search(keyword) != -1
                true
            else if obj.Nickname? and obj.Nickname.search(keyword) != -1
                true 
            else
                false
        #dbFiltered = tmpList
    if type.length !=0
        dbFiltered= _.filter dbFiltered,(obj)->
            if obj.Type.search(type) != -1
                true
            else
                false
    if color.length !=0
        dbFiltered = _.filter dbFiltered, (obj)->
            _.contains(color,obj.CardColor_Ch)

    if icon.length !=0
        dbFiltered = _.filter dbFiltered,(obj)->
            if obj.Icon.search(icon) != -1
                true
            else
                false

    if race.length !=0
        dbFiltered = _.filter dbFiltered,(obj)->
            if obj.Race.search(race) != -1
                true
            else
                false
    if cardset.length !=0
        dbFiltered = _.filter dbFiltered,(obj)->
            if obj.CardSet.search(cardset) != -1
                true
            else
                false
    if rarity.length !=0 
        dbFiltered = _.filter dbFiltered,(obj) ->
            if obj.Rarity.search(rarity) != -1
                true
            else
                false

    if tags.length !=0
        dbFiltered= _.filter dbFiltered,(obj)->
            _.contains(tags,obj.Tag)
            
    RenderMain()
    return
            



