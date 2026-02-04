## Uses a viewport method of composing card elements into a Texture2D
class_name P_Viewport_CardCompositor extends P_CardCompositor

var _Viewport: SubViewport
var _Root: Node2D
var _Background: Sprite2D
var _Graphic: Sprite2D
var _StanceTop: Sprite2D
var _StanceMiddle: Sprite2D
var _StanceBottom: Sprite2D
var _Text: Sprite2D
var _Chrome: Sprite2D

func _Composite(owner: Node, params: P_CardCompositor.CompositeParams) -> Texture2D:
	if owner == null:
		push_error("Owner is null")

	if params == null:
		push_error("params is null")

	if owner.is_node_ready() != true:
		push_error("Cannot composite cards, owner %s is not ready" % owner)

	if _Viewport == null:
		_Viewport = SubViewport.new()

		_Root = Node2D.new()
		_Background = Sprite2D.new()
		_Graphic = Sprite2D.new()
		_StanceTop = Sprite2D.new()
		_StanceMiddle = Sprite2D.new()
		_StanceBottom = Sprite2D.new()
		_Text = Sprite2D.new()
		_Chrome = Sprite2D.new()

		_Viewport.add_child(_Root)
		_Root.add_child(_Background)
		_Root.add_child(_Graphic)
		_Root.add_child(_StanceTop)
		_Root.add_child(_StanceMiddle)
		_Root.add_child(_StanceBottom)
		_Root.add_child(_Text)
		_Root.add_child(_Chrome)

		_Background.position = Vector2.ZERO
		_Graphic.position = Vector2.ZERO
		_StanceTop.position = Vector2(0, 0)
		_StanceMiddle.position = Vector2(0, 300)
		_StanceBottom.position = Vector2(0, 600)

		_Background.centered = false
		_Graphic.centered = false
		_StanceTop.centered = false
		_StanceMiddle.centered = false
		_StanceBottom.centered = false
		
		_Viewport.disable_3d = true
		_Viewport.render_target_update_mode = SubViewport.UPDATE_ONCE
		_Viewport.render_target_clear_mode = SubViewport.CLEAR_MODE_ALWAYS
		_Viewport.size = Vector2i(600, 900)

	print("rending card %s" % params.InstID)
	_Background.texture = params.Background
	_Graphic.texture = params.Graphic
	_StanceTop.texture = params.Top
	_StanceMiddle.texture = params.Middle
	_StanceBottom.texture = params.Bottom
	_Chrome.texture = params.Chrome

	owner.add_child(_Viewport)
	_Viewport.render_target_update_mode = SubViewport.UPDATE_ONCE
	await RenderingServer.frame_post_draw
	var texture = _Viewport.get_texture()
	owner.remove_child(_Viewport)

	# Bake
	var baked = ImageTexture.create_from_image(texture.get_image())
	return baked
