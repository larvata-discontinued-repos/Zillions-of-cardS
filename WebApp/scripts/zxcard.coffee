getRaceIdByName = (race)->
	switch race
		# red
		when "勇者" then return 1
		when "巨兽" then return 2
		when "技师" then return 3
		when "神兽" then return 4
		when "荣光龙" then return 5
		# blue
		when "战斗服" then return 6
		when "金属要塞" then return 7
		when "人鱼" then return 8
		when "杀人机械" then return 9
		when "齿轮龙" then return 10
		# golden
		when "天使" then return 11
		when "守护者" then return 12
		when "圣兽" then return 13
		when "猫妖精" then return 14
		when "神使龙" then return 15
		# purple
		when "魔人" then return 16
		when "捕食者" then return 17
		when "不死者" then return 18
		when "拷问刑具" then return 19
		when "残酷龙" then return 20
		# green
		when "蓬莱" then return 21
		when "兽化人" then return 22
		when "叶人" then return 23
		when "花虫" then return 24
		when "藤蔓龙" then return 25
		# red
		when "拉哈鲁" then return 26
		when "玛奥" then return 27
		when "拉兹贝莉露" then return 28
		when "中BOSS" then return 29
		# blue
		when "亚莎纪" then return 30
		when "阿迪鲁" then return 31
		when "罗萨莉" then return 32
		when "阿库塔雷" then return 33
		# golde
		when "芙蓉" then return 34
		when "莉莉艾尔" then return 35
		when "阿尔蒂娜" then return 36
		when "普莉耶" then return 37
		when "普拉姆" then return 38
		# purple
		when "艾多娜" then return 39
		when "瓦尔巴特杰" then return 40
		when "死亡子" then return 41
		when "风花" then return 42
		# green
		when "普利尼" then return 43
		when "玛洛妮" then return 44
		when "亚修" then return 45
		when "梅塔莉卡" then return 46
		when "百骑兵" then return 47
		when "碧丝可" then return 48
		when "迷宫小姐" then return 49

$ ->

	# add an uniq id for each card entity
	# this code is very bukexue
	_.each dbMain,(value,key)->
		#value.Disabled = true if value.Version.length>0
			
		list = _.filter dbMain, (obj)-> 
			obj.CardName_Ch is value.CardName_Ch

		# set !first sameNameCart as disabled
		_.each list,(value,key)->
			if key is 0
				value.Disabled = false 
			else
				value.Disabled = true
		# code for extract card relation of same cardName
		_.extend value,{Relations:list}
		_.extend value,{Id:key}
		
	$('.about-card-count').text(_.filter(dbMain,(card)->!card.Disabled).length)
	$('.about-card-count-total').text(dbMain.length)

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
			Rarity       : '', # 罕贵度
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
			@currentIndex = 0
			_.bindAll(this,'cardNav')
			$(document).bind('keydown',this.cardNav)
			@collection = cardListCollection
			@filteredList = _.chain(@collection.models).filter((card)->card.get('Filtered') is false and card.get('Disabled') is false).value()
			@render()

		render: ->
			@$el.html(@template({CardList:@collection.toJSON()}))
			
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
				@currentIndex=@filteredList.indexOf(model)
			else
				model = @filteredList[@currentIndex]

			$('.main-filter-result a').removeClass('actived')
			$(".main-filter-result a[data-id=#{model.get('Id')}]").addClass('actived')
			
			cardSummaryView = new CardSummaryView({model})
			cardDetailsView = new CardDetailsView({model})

		cardNav: (event)->
			if document.activeElement is document.body
				event.cancelBubble = true #IE
				event.stopPropagation() if event.stopPropagation #other browsers

				lastIndex=@currentIndex

				switch event.keyCode
					#when 37
					when 38
						@currentIndex-- if @currentIndex > 0
					#when 39
					when 40
						@currentIndex++ if @currentIndex < @filteredList.length-1
				@renderCardDetails() if lastIndex != @currentIndex
			
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
			@model.set('Race',_.chain(@collection.pluck("Race")).uniq().compact().without("-").sortBy((race)->
				getRaceIdByName(race);
			).value())

			@model.set('CardSet',_.chain(@collection.pluck("CardSet")).uniq().compact().without("-").value())
			@model.set('Rarity',_.chain(@collection.pluck("Rarity")).uniq().compact().without("-").sortBy((rarity)->
				switch rarity.toLowerCase()
					when "cvr" then return 1
					when "igr" then return 2
					when "z/xr" then return 3
					when "sr" then return 4
					when "r" then return 5
					when "uc" then return 6
					when "c" then return 7
					when "f" then return 8
					when "pr" then return 9
					else return 99
			).value())

			@model.set('Tag',_.chain(@collection.pluck("Tag")).uniq().compact().without("-").sortBy((tag)->
				switch tag
					when "生命恢复" then 1
					when "虚空使者" then 2
					when "起始卡" then 3
					when "范围2" then 4
					when "范围∞" then 5
					when "绝界" then 6
			).value())

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
			colors : _.pluck($(".filter-colors input:checked"),"value")
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
					if ((!model.get('CardName_Ch')? or model.get('CardName_Ch').search(conditions.keyword) is -1) and (!model.get('CardName_Jp')? or model.get('CardName_Jp').search(conditions.keyword) is -1) and (!model.get('Nickname')? or model.get('Nickname').search(conditions.keyword) is -1) and (!model.get('SerialNo')? or model.get('SerialNo').toLowerCase().search(conditions.keyword.toLowerCase()) is -1))
						model.set('Filtered',true)
				
				if conditions.type.length != 0
					if model.get('Type').search(conditions.type) is -1
						model.set('Filtered',true)

				if conditions.colors.length != 0
					if not _.contains(conditions.colors, model.get('CardColor_Ch'))
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

			$(document).unbind('keydown')
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
	app = new AppView()






