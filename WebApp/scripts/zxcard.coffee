
$ ->

	# add an uniq id for each card entity
	_.each dbMain,(value,key)->
		value.Disabled = true if value.Version.length>0
			
		list = _.filter dbMain, (obj)-> 
			obj.CardName_Ch is value.CardName_Ch
		# code for extract card relation of same cardName
		_.extend value,{Relations:list}
		_.extend value,{Id:key}
		
	$('.about-card-count').text(dbMain.length)

	FilterModel = Backbone.Model.extend(
		defaults: {
			Keyword      : '', # 关键词
			Type         : '', # 卡片类型
			Colors       : '', # 卡片颜色
			Cost         : '', # 费用
			Cost_Method  : '', # 费用筛选方向
			Power        : '', # 力量
			Power_Method : '', # 力量筛选方向
			Icon         : '', # 标记
			Race         : '', # 种族
			CardSet      : '', # 卡组
			Rearity      : '', # 稀有度
			Tags         : ''  # 
		}
	)


	CardSummaryView = Backbone.View.extend(
		el: '.main-card-summary'
		template: _.template($('#cardSummaryTemplate').html())

		initialize: ->
			@render()

		render: ->
			@$el.html(@template({Card:@model.toJSON()})) if @model?

		events:
			"change .card-summary-versions": "cardVersionChange"
			"reset":"resetModel"

		cardVersionChange:  (event)->
			if @collection?
				id = $(event.currentTarget).find('option:selected').data('id')
				model = @collection.byId(id)
				cardSummaryView = new CardSummaryView({model})
				cardDetailsView = new CardDetailsView({model})

	)

	CardDetailsView = Backbone.View.extend(
		el: '.main-card-detail'
		template: _.template($('#cardDetailsTemplate').html())

		initialize: ->
			@render()

		render: ->

			if @model?
				@$el.html(@template({Card:@model.toJSON()}))

				# reset container class
				@$el.attr("class","main-card-detail col-lg-4 col-md-3")
				# set class by color
				# 蓝|blue", "白|white", "黑|black", "绿|green","红|red","无|mu","龙|dragon
				classSuffix = ""
				switch @model.toJSON().CardColor_Ch
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
				@$el.addClass("card-color-#{classSuffix}")
			

		events:
			"click li": "navtabsChange"

		navtabsChange:  (event)->
			if event?
				tab = $(event.currentTarget).data("tab") 
			else
				tab = 'desc'
			$('.zx-tab-pages div').hide()
			$(".zx-tab-pages div[data-tab=#{tab}]").show()
			$('.zx-card-tabs li').removeClass('active')
			$(".zx-card-tabs li[data-tab=#{tab}]").addClass('active')
	)

	CardListView = Backbone.View.extend(
		el: '.main-filter-result'
		template: _.template($('#cardListTemplate').html())

		initialize: ->
			@collection = cardListCollection
			#console.log @collection
			@render()

		render: ->
			@$el.html(@template({CardList:@collection.toJSON()}))
			
			$('.main-filter-result a').click ->
				$('.main-filter-result a').removeClass('actived')
				$(@).addClass('actived')

			# load first card when cardlist loaded
			@renderCardDetails() if @collection.length > 0

		events:{
			"click a": "renderCardDetails"
		}

		renderCardDetails: (event)->
			if event?
				ele = $(event.toElement).closest('a')
				id = ele.data("id")
				model = @collection.models[id]
			else
				model = _.find(@collection.models, (model)->
					model.get('Filtered') is false and model.get('Disabled') is false
				)
			
			cardSummaryView = new CardSummaryView({model})
			cardDetailsView = new CardDetailsView({model})
	)

	FilterPanelView = Backbone.View.extend(
		el: '.zx-panel-filter'
		template: _.template($('#filterPanelTemplate').html())

		initialize: ->
			@model = new FilterModel()
			@collection = cardListCollection

			@model.set('Type',_.chain(@collection.pluck("Type")).uniq().compact().without("-").value())
			@model.set('Colors',_.chain(@collection.pluck("CardColor_Ch")).uniq().compact().without("-").value())
			@model.set('Cost',_.chain(@collection.pluck("Cost")).uniq().compact().without("-").sortBy((cost)-> parseInt(cost)).value())
			@model.set('Power',_.chain(@collection.pluck("Power")).uniq().compact().without("-").sortBy((power)-> parseInt(power)).value())
			@model.set('Icon',_.chain(@collection.pluck("Icon")).uniq().compact().without("-").value())
			@model.set('Race',_.chain(@collection.pluck("Race")).uniq().compact().without("-").value())
			@model.set('CardSet',_.chain(@collection.pluck("CardSet")).uniq().compact().without("-").value())
			@model.set('Rarity',_.chain(@collection.pluck("Rarity")).uniq().compact().without("-").value())
			@model.set('Tag',_.chain(@collection.pluck("Tag")).uniq().compact().without("-").value())

			@$el.html(@template({filterData:@model.toJSON()}))


		events:
			"click .btn-reset": "resetFilterConditions"
			"keyup .filter-keyword": "filterCards"
			"change .filter-keyword": "filterCards"
			"change .filter-types":"filterCards"
			"change .filter-colors":"filterCards"
			"change .filter-costs":"filterCards"
			"change .filter-cost-method":"filterCards"
			"change .filter-powers":"filterCards"
			"change .filter-power-method":"filterCards"
			"change .filter-icons":"filterCards"
			"change .filter-races":"filterCards"
			"change .filter-cardsets":"filterCards"
			"change .filter-rarities":"filterCards"
			"change .filter-tags":"filterCards"

		resetFilterConditions: ->
			$(".filter-keyword").val("")
			$(".filter-colors label").removeClass("active")
			$(".filter-colors input").prop("checked",false)
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
			@filterCards()

		getFilterCondition: ->
			keyword : $(".filter-keyword").val()
			type : $(".filter-types").val()
			color : _.pluck($(".filter-colors input:checked"),"value")
			icon : $(".filter-icons").val()
			race : $(".filter-races").val()
			cardset : $(".filter-cardsets").val()
			rarity : $(".filter-rarities").val()
			tags : _.pluck($(".filter-tags input:checked"),"value")
			cost : $(".filter-costs").val()
			cost_operation : $(".filter-cost-method").val()
			power : $(".filter-powers").val()
			power_operation : $(".filter-power-method").val()
			


		filterCards: ->
			conditions = @getFilterCondition()
			
			_.each @collection.models, (model)->
				model.set('Filtered',false)

				if conditions.keyword.length != 0
					if (model.get('CardName_Ch')? and model.get('CardName_Ch').search(conditions.keyword) is -1) and (model.get('CardName_Jp')? and model.get('CardName_Jp').search(conditions.keyword) is -1) and (model.get('Nickname')? and model.get('Nickname').search(conditions.keyword) is -1)
						model.set('Filtered',true)
				
				if conditions.type.length != 0
					if model.get('Type').search(conditions.type) is -1
						model.set('Filtered',true)

				if conditions.color.length != 0
					if conditions.color is model.get('CardColor_Ch')
						model.set('Filtered',true)
						
				if conditions.icon.length != 0
					if model.get('Icon').search(conditions.icon) is -1
						model.set('Filtered',true)

				if conditions.race.length != 0
					if model.get('Race').search(conditions.race) is -1
						model.set('Filtered',true)

				if conditions.cardset.length != 0
					if model.get('CardSet').search(conditions.cardset) is -1
						model.set('Filtered',true)

				if conditions.rarity.length != 0
					if model.get('Rarity').search(conditions.rarity) is -1
						model.set('Filtered',true)

				if conditions.tags.length != 0
					if not _.contains(conditions.tags,model.get('Tag'))
						model.set('Filtered',true)

				if parseInt(conditions.cost) != -1
					switch conditions.cost_operation
						when ">"
							model.set('Filtered',true) if parseInt(model.get('Cost')) <= parseInt(conditions.cost)
						when "<"
							model.set('Filtered',true) if parseInt(model.get('Cost')) >= parseInt(conditions.cost)
						when "="
							model.set('Filtered',true) if parseInt(model.get('Cost')) != parseInt(conditions.cost)

				if parseInt(conditions.power) != -1
					switch conditions.power_operation
						when ">"
							model.set('Filtered',true) if parseInt(model.get('Power')) <= parseInt(conditions.power)
						when "<"
							model.set('Filtered',true) if parseInt(model.get('Power')) >= parseInt(conditions.power)
						when "="
							model.set('Filtered',true) if parseInt(model.get('Power')) != parseInt(conditions.power)
						
					

			new CardListView()

	)



	AppView = Backbone.View.extend(
		initialize: ->
			new CardListView()

		render: ->
			return

		displayCardDetails: ->
			return

		filter: ->
			return
	)

	CardModel = Backbone.Model.extend(
			defaults: {
				# Data
				CardSet         :  '', # 卡组
				CardColor_Ch    :  '', # 卡片颜色 中文
				CardColor_En    :  '', # 卡片颜色 英文(未使用)
				SerialNo        :  '', # 卡号
				Version         :  '', # 版本
				Img_Suffix      :  '', # 
				CardName_Jp     :  '', # 卡名 日文
				CardName_Ch     :  '', # 卡名 中文
				Rarity          :  '', # 稀有度
				Type            :  '', # 卡片类型
				Race            :  '', # 种族
				Cost            :  0 , # 费用
				Power           :  0 , # 力量
				Icon            :  '', # 标记
				Ability_Ch      :  '', # 能力描述 中文
				Ability_Jp      :  '', # 能力描述 日文
				Description_Ch  :  '', # 卡片描述 中文
				Description_Jp  :  '', # 卡片描述 日文
				Neta            :  '', # 捏他
				Relation        :  '', # 
				Illustrator     :  '', # 画师
				Tag             :  '', # 
				Nickname        :  '', # 昵称
				Ruling          :  '', # 
				TsugKomi        :  ''  # 吐槽

				# Flag
				Filtered        : false # 被过滤
				Disabled        : false # 同名卡片
				Selected        : false #
			}
	)

	CardList = Backbone.Collection.extend(
			model: CardModel

			initialize: ->
				@on("reset", ->
					alert "reseted"
				)

			byId: (id)->
				filtered = @filter (card)->
					return card.get("Id") is id
				return filtered[0]

			events:
				"change" : "valueChanged"

			valueChanged: ->
				alert "valueChanged"
	)

	cardListCollection = new CardList(dbMain)
	cardSummaryView = new CardSummaryView(cardListCollection.models[0])
	cardDetailsView = new CardDetailsView(cardListCollection.models[0])

	panel = new FilterPanelView()
	#cardListView = 
	app = new AppView()






