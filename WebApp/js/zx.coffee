
dbUrl = "http://zx.colintrinity.com/"
dbFiltered = undefined
dbZXCard= new Array()
cardNameUniqList = undefined
# dbMain = undefined
# $.get "db/abcout.json", (data) ->
#   dbMain = $.parseJSON(data)
#   dbFiltered = dbMain
#   Init()

$(document).ready ->
    _.each dbMain,(value,key)->
        dbZXCard.push _.extend value,{Id:key}

    Init()

RenderFilterOptions = ->
    # 种类
    cardTypeList=_.chain(dbZXCard).pluck("Type").uniq().compact().without("-").without("－").value()
    $(".filter-types").children().remove()
    _.each cardTypeList ,(type)->
        $(".filter-types").append("<option value='#{type}'>#{type}</option>")
    if cardTypeList.length < 1
        $(".filter-types").prop("disabled",true) 
    else
        $(".filter-types").prepend("<option value=''>(All)</option>")

    # 颜色
    cardColorList=_.chain(dbZXCard).pluck("CardColor_Ch").uniq().compact().without("-").without("－").value()
    $(".filter-colors").children().remove()
    _.each cardColorList, (color)->
        $(".filter-colors").append("<label class='btn btn-primary btn-xs'><input type='checkbox' value='#{color}'>#{color}</label>")

    # 费用
    cardCostList=_.chain(dbZXCard).pluck("Cost").uniq().compact().without("-").without("－").sortBy((cost)-> parseInt(cost)).value()
    $(".filter-costs").children().remove()
    _.each cardCostList,(cost)->
        $(".filter-costs").append("<option>#{cost}</option>")
    if cardCostList.length < 1
        $(".filter-cost-method").prop("disabled",true) 
    else
        $(".filter-costs").prepend("<option value='-1'>(费用)</option>")

    # 力量
    cardPowerList=_.chain(dbZXCard).pluck("Power").uniq().compact().without("-").without("－").sortBy((power)-> parseInt(power)).value()
    $(".filter-powers").children().remove()
    _.each cardPowerList,(power)->
        $(".filter-powers").append("<option>#{power}</option>")
    if cardPowerList.length < 1
        $(".filter-power-method").prop("disabled",true) 
    else
        $(".filter-powers").prepend("<option value='-1'>(力量)</option>")

    # 标记
    cardIconList=_.chain(dbZXCard).pluck("Icon").uniq().compact().without("-").without("－").value()
    $(".filter-icons").children().remove()
    _.each cardIconList,(icon)->
        $(".filter-icons").append("<option value='#{icon}'>#{icon}</option>")
    if cardIconList.length < 1
        $(".filter-icons").prop("disabled",true) 
    else
        $(".filter-icons").prepend("<option value=''>(标记)</option>")
    
    # 种族
    cardRaceList=_.chain(dbZXCard).pluck("Race").uniq().compact().without("-").without("－").value()
    $(".filter-races").children().remove()
    _.each cardRaceList,(race)->
        $(".filter-races").append("<option value='#{race}'>#{race}</option>")
    if cardRaceList.length < 1
        $(".filter-races").prop("disabled",true) 
    else
        $(".filter-races").prepend("<option value=''>(种族)</option>")

    # 卡包
    cardSetList=_.chain(dbZXCard).pluck("CardSet").uniq().compact().without("-").without("－").value()
    $(".filter-cardsets").children().remove()
    _.each cardSetList,(set)->
        $(".filter-cardsets").append("<option value='#{set}'>#{set}</option>")
    if cardSetList.length < 1
        $(".filter-cardsets").prop("disabled",true) 
    else
        $(".filter-cardsets").prepend("<option value=''>(卡包)</option>")

    # 罕贵度
    cardRarityList=_.chain(dbZXCard).pluck("Rarity").uniq().compact().without("-").without("－").value()
    $(".filter-rarities").children().remove()
    _.each cardRarityList,(rarity)->
        $(".filter-rarities").append("<option value='#{rarity}'>#{rarity}</option>")
    if cardRarityList.length < 1
        $(".filter-rarities").prop("disabled",true) 
    else
        $(".filter-rarities").prepend("<option value=''>(罕贵度)</option>")

    # 效果分类
    cardTagList=_.chain(dbZXCard).pluck("Tag").uniq().compact().without("-").without("－").value()
    $(".filter-tags").children().remove()
    _.each cardTagList,(tag)->
        $(".filter-tags").append("<label class='btn btn-primary btn-xs'><input type='checkbox' value='#{tag}'>#{tag}</label>")
    # $(".filter-tags label").addClass("active")
    # $(".filter-tags input").prop("checked",true)

Init = () ->

    # get uniq serialNo from maindb
    cardNameUniqList=_.chain(dbZXCard).pluck("CardName_Ch").uniq().compact().without("-").without("－").value()

    # set cards count in about dialog
    $(".about-card-count").text(dbMain.length)

    # redraw filter-options
    RenderFilterOptions()

    # bind event
    $(".card-summary-details").click ->
        window.open dbUrl + encodeURIComponent($(@).data("card-name-jp"))

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

    $(".filter-costs").change ->
        FilterCards()

    $(".filter-cost-method").change ->
        FilterCards()

    $(".filter-powers").change ->
        FilterCards()

    $(".filter-power-method").change ->
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
        filter_result_container.append("<a data-id='#{dbFiltered[i].Id}'><span>#{dbFiltered[i].CardName_Ch}</span></a>")

    $(".main-filter-result a").click ->
        $(".card-summary-versions").children().remove()
        id=$(@).data("id")
        _.each dbZXCard, (value,key)->
            if value.CardName_Ch is dbZXCard[id].CardName_Ch
                value.Version = "" if _.isNull(value.Version)
                $(".card-summary-versions").append("<option data-id='#{value.Id}'>#{value.SerialNo+value.Version}</option>")
                return
        $(".card-summary-versions").change ->
            RenderCardInfo($(@).find("option:checked").data("id"))
            return
        RenderCardInfo($(@).data("id"))

    $(".main-filter-result a:first-child").click()

RenderCardInfo = (id)->
    $(".main-filter-result a.actived").removeClass("actived")
    $(".main-filter-result a[data-id=#{id}]").addClass("actived")
    # redraw card main details by card database id
    # replace null with "" to avoid wrong pic url
    dbZXCard[id].Img_Suffix= "" if _.isNull(dbZXCard[id].Img_Suffix)
    $(".card-summary-image").css("background-image","url(images/card-img/#{dbZXCard[id].SerialNo+dbZXCard[id].Img_Suffix}.png)")
    $(".card-summary-illustrator").text(dbZXCard[id].Illustrator)
    $(".card-summary-details").data("card-name-jp",dbZXCard[id].CardName_Jp)
    
    # reset container class
    $(".main-card-detail").attr("class","main-card-detail col-lg-4 col-md-3")
    # set class by color
    # 蓝|blue", "白|white", "黑|black", "绿|green","红|red","无|mu","龙|dragon
    classSuffix = ""
    switch dbZXCard[id].CardColor_Ch
        when "蓝"
            classSuffix = "blue"
        when "白"
            classSuffix = "white"
        when "黑"
            classSuffix = "black"
        when "绿"
            classSuffix = "green"
        when "红"
            classSuffix = "red"
        when "无"
            classSuffix = "mu"
        when "龙"
            classSuffix = "dragon"
    $(".main-card-detail").addClass("card-color-#{classSuffix}")

    card_tags_container=$(".card-detail-tags")
    card_tags_container.children().remove()
    card_tags_container.append("<span class='icon'></span>")
    card_tags_container.append("<span class='label label-default'>#{dbZXCard[id].SerialNo}</span>")
    card_tags_container.append("<span class='label label-default'>#{dbZXCard[id].Rarity}</span>")
    card_tags_container.append("<span class='label label-default'>#{dbZXCard[id].Race}</span>")
    card_tags_container.append("<span class='label label-default'>#{dbZXCard[id].Type}</span>")
    $(".card-detail-cardname-ch").text(dbZXCard[id].CardName_Ch)
    $(".card-detail-cardname-jp").text(dbZXCard[id].CardName_Jp)
    $(".card-detail-cost").text(dbZXCard[id].Cost)
    $(".card-detail-power").text(dbZXCard[id].Power)

    $(".card-detail-icon").attr("class","card-detail-icon card-detail-fontsize-large")
    if dbZXCard[id].Icon is "-" or "－"
        $(".card-detail-icon").text("-")
    else
        $(".card-detail-icon").addClass("card-icon ")
        $(".card-detail-icon").addClass("icon-#{dbZXCard[id].Icon.toLowerCase()}")


    $(".card-detail-ability-ch").text(dbZXCard[id].Ability_Ch)
    $(".card-description textarea").text(dbZXCard[id].Description_Ch)
    $(".card-neta textarea").text(_.isNull(dbZXCard[id].Neta)?"":dbZXCard[id].Neta)
    $(".card-ruling textarea").text(_.isNull(dbZXCard[id].Ruling)?"":dbZXCard[id].Ruling)
    return

ResetFilters = () ->
    $(".filter-keyword").val("")
    $(".filter-types option:first-child").prop("selected",true)
    $(".filter-cost-method option:first-child").prop("selected",true)
    $(".filter-costs option:first-child").prop("selected",true)
    $(".filter-powers option:first-child").prop("selected",true)
    $(".filter-power-method option:first-child").prop("selected",true)
    $(".filter-icons option:first-child").prop("selected",true)
    $(".filter-races option:first-child").prop("selected",true) 
    $(".filter-cardsets option:first-child").prop("selected",true)
    $(".filter-rarities option:first-child").prop("selected",true)
    $(".filter-tags label").removeClass("active")
    $(".filter-tags input").prop("checked",false)
    FilterCards()

FilterCards = () ->
    dbFiltered = dbZXCard

    keyword = $(".filter-keyword").val()
    type = $(".filter-types").val()    
    color = _.pluck($(".filter-colors input:checked"),"value")
    icon=$(".filter-icons").val()
    race=$(".filter-races").val()
    cardset=$(".filter-cardsets").val()
    rarity=$(".filter-rarities").val()
    tags=_.pluck($(".filter-tags input:checked"),"value")
    cost=  $(".filter-costs").val()
    power= $(".filter-powers").val()

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

    if cost != "-1"
        opt=$(".filter-cost-method").val()
        dbFiltered= _.filter dbFiltered,(obj)->
            false if obj.Cost is "-" or "－"
            switch opt
                when ">"
                    parseInt(obj.Cost) > parseInt(cost)
                when "="
                    parseInt(obj.Cost) == parseInt(cost)
                when "<"
                    parseInt(obj.Cost) < parseInt(cost)


    if power != "-1"
        opt=$(".filter-power-method").val()
        dbFiltered= _.filter dbFiltered,(obj)->
            false if obj.Power is "-" or "－"
            switch opt
                when ">"
                    parseInt(obj.Power) > parseInt(power)
                when "="
                    parseInt(obj.Power) == parseInt(power)
                when "<"
                    parseInt(obj.Power) < parseInt(power)

    # filter card info with same serialNo
    tmpUniqLst = cardNameUniqList
    dbFiltered = _.filter dbFiltered, (obj)->
        if _.contains tmpUniqLst,obj.CardName_Ch
            tmpUniqLst = _.without tmpUniqLst,obj.CardName_Ch
            true
        else
            false
            
    RenderMain()
    return
            



