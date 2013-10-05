$ ->

	# add an uniq id for each card entity
	_.each dbMain,(value,key)->
		value.Disabled = true if value.Version.length>0

		list = _.filter dbMain, (obj)-> 
			obj.CardName_Ch is value.CardName_Ch
		# code for extract card relation of same cardName
		_.extend value,{Relations:list}
		_.extend value,{Id:key}
		



	FilterPanelModel = Backbone.Model.extend(
		defaults: {
			Keyword      : '', # 关键词
			Type         : '', # 卡片类型
			Colors       : '', # 卡片颜色
			Cost         : '', # 消耗
			Cost_Method  : '', # 消耗筛选方向
			Power        : '', # 力量
			Power_Method : '', # 力量筛选方向
			Icon         : '', # 标记
			Race         : '', # 种族
			CardSet      : '', # 卡组
			Rearity      : '', # 稀有度
			Tags         : ''  # 
		}
	)

	FilterPanelView = Backbone.View.extend(
		initialize: ->
			@model = new FilterPanelModel()
		events: {

		}

		filterByKeywords:->

	)

	CardDetailsView = Backbone.View.extend(
		el_s: '.main-card-summary'
		el_d: '.main-card-detail'
		template_s: _.template($('#cardSummaryTemplate').html())
		template_d: _.template($('#cardDetailsTemplate').html())

		initialize: ->
			@render()
		render: ->

			$(@el_s)[0].outerHTML = @template_s({Card:@model.toJSON()})
			$(@el_d)[0].outerHTML = @template_d({Card:@model.toJSON()})

			#bind nav-tabs event
			$('.zx-card-tabs li').click ->
				tab = $(this).data('tab')
				$('.zx-tab-pages div').hide()
				$(".zx-tab-pages div[data-tab=#{tab}]").show()
				$('.zx-card-tabs li').removeClass('active')
				$(".zx-card-tabs li[data-tab=#{tab}]").addClass('active')

		renderByIndex: (index)->


	)

	CardListView = Backbone.View.extend(
		el: '.main-filter-result'
		template: _.template($('#cardListTemplate').html())

		initialize: ->
			@collection = new CardList(dbMain)
			#console.log @collection
			@render()

		render: ->
			@$el.append(@template({CardList:@collection.toJSON()}))
			
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
			else
				id = 0
			model = @collection.models[id]




			cardDetailsView = new CardDetailsView({model})

	)
	AppView = Backbone.View.extend(
		initialize: ->

			
			@render

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
				Cost            :  0 , # 消耗
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

		)

	cardListView = new CardListView()
	app = new AppView()





