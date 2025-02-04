package fairygui.action;
class ChangePageAction extends ControllerAction
{
    public var objectId:String;
    public var controllerName:String;
    public var targetPage:String;

    public function new()
    {
        super();
    }

    override private function enter(controller:Controller):Void
    {
        if (controllerName == null)
            return;

        var gcom:GComponent;
        if (objectId != null)
            gcom = cast(controller.parent.getChildById(objectId), GComponent);
        else
            gcom = controller.parent;

        if (gcom != null)
        {
            var cc:Controller = gcom.getController(controllerName);
            if (cc != null && cc != controller && !cc.changing)
                cc.selectedPageId = targetPage;
        }
    }

    override public function setup(xml:FastXML):Void
    {
        super.setup(xml);

        objectId = xml.AttrAccess("objectId");
        controllerName = xml.AttrAccess("controller");
        targetPage = xml.AttrAccess("targetPage");
    }
}
