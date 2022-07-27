package fairygui;

import openfl.errors.Error;
class UIObjectFactory
{
    @:allow(fairygui)
    private static var packageItemExtensions : Map<String, Class<Dynamic>> = new Map<String, Class<Dynamic>>();
    private static var loaderType : Class<Dynamic>;
    
    public function new()
    {
    }
    
    public static function setPackageItemExtension(url : String, type : Class<Dynamic>) : Void
    {
        if (url == null)
            throw new Error("Invaild url: " + url);

        var pi:PackageItem = UIPackage.getItemByURL(url);
        if (pi != null)
            pi.extensionType = type;

        packageItemExtensions[url] = type;
    }
    
    public static function setLoaderExtension(type : Class<Dynamic>) : Void
    {
        loaderType = type;
    }

    @:allow(fairygui)
    private static function resolvePackageItemExtension(pi:PackageItem):Void
    {
        pi.extensionType = packageItemExtensions["ui://" + pi.owner.id + pi.id];
        if(pi.extensionType == null)
            pi.extensionType = packageItemExtensions["ui://" + pi.owner.name + "/" + pi.name];
    }
    
    public static function newObject(pi : PackageItem) : GObject
    {
        switch (pi.type)
        {
            case PackageItemType.Image:
                return new GImage();
            
            case PackageItemType.MovieClip:
                return new GMovieClip();
            
            case PackageItemType.Swf:
                return new GSwfObject();
            
            case PackageItemType.Component:
            {
                var cls : Class<Dynamic> = pi.extensionType;
                if (cls != null) 
                    return Type.createInstance(cls, []);
                
                var xml : FastXML = pi.owner.getComponentData(pi);
                var extention : String = xml.AttrAccess("extention");
                if (extention != null) 
                {
                    switch (extention)
                    {
                        case "Button":
                            return new GButton();
                        
                        case "Label":
                            return new GLabel();
                        
                        case "ProgressBar":
                            return new GProgressBar();
                        
                        case "Slider":
                            return new GSlider();
                        
                        case "ScrollBar":
                            return new GScrollBar();
                        
                        case "ComboBox":
                            return new GComboBox();
                        
                        default:
                            return new GComponent();
                    }
                }
                else 
                    return new GComponent();
            }
        }
        return null;
    }
    
    public static function newObject2(type : String) : GObject
    {
        switch (type)
        {
            case "image":
                return new GImage();
            
            case "movieclip":
                return new GMovieClip();
            
            case "swf":
                return new GSwfObject();
            
            case "component":
                return new GComponent();
            
            case "text":
                return new GTextField();
            
            case "richtext":
                return new GRichTextField();
            
            case "inputtext":
                return new GTextInput();
            
            case "group":
                return new GGroup();
            
            case "list":
                return new GList();
            
            case "graph":
                return new GGraph();
            
            case "loader":
                if (loaderType != null)
                    return Type.createInstance(loaderType, []);
                else 
                    return new GLoader();
        }
        return null;
    }
}
