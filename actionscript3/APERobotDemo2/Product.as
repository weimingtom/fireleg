package example.externalizable
{

import flash.utils.IExternalizable;
import flash.utils.IDataInput;
import flash.utils.IDataOutput;

[RemoteClass(alias="example.externalizable.Product")]
public class Product implements IExternalizable
{
    public function Product(name:String=null)
    {
        if (this.name == null)
            this.name = name;
    }

    public function get id():String
    {
        return _id;
    }

    public function readExternal(input:IDataInput):void
    {
        _id = input.readObject() as String;
        name = input.readObject() as String;
        description = input.readObject() as String;
        price = input.readInt();
    }

    public function writeExternal(output:IDataOutput):void
    {
        output.writeObject(id);
        output.writeObject(name);
        output.writeObject(description);
        output.writeInt(price);       
    }

    public var name:String;
    public var description:String;
    public var price:int;    
    private var _id:String;
}
    
}