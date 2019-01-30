module autowrap.csharp.common;

public import std.datetime : DateTime, SysTime, Date, TimeOfDay, Duration, TimeZone;
public import std.traits : Unqual;

package enum string voidTypeString = "void";
package enum string stringTypeString = "string";
package enum string wstringTypeString = "wstring";
package enum string dstringTypeString = "dstring";
package enum string boolTypeString = "bool";
package enum string dateTimeTypeString = "std.datetime.date.DateTime";
package enum string sysTimeTypeString = "std.datetime.systime.SysTime";
package enum string dateTypeString = "std.datetime.date.Date";
package enum string timeOfDayTypeString = "std.datetime.date.TimeOfDay";
package enum string durationTypeString = "core.time.Duration";
package enum string uuidTypeString = "UUID";
package enum string charTypeString = "char";
package enum string wcharTypeString = "wchar";
package enum string dcharTypeString = "dchar";
package enum string ubyteTypeString = "ubyte";
package enum string byteTypeString = "byte";
package enum string ushortTypeString = "ushort";
package enum string shortTypeString = "short";
package enum string uintTypeString = "uint";
package enum string intTypeString = "int";
package enum string ulongTypeString = "ulong";
package enum string longTypeString = "long";
package enum string floatTypeString = "float";
package enum string doubleTypeString = "double";
package enum string sliceTypeString = "slice";

public enum isDateTimeType(T) = is(T == Unqual!Date) || is(T == Unqual!DateTime) || is(T == Unqual!SysTime) || is(T == Unqual!TimeOfDay) || is(T == Unqual!Duration) || is(T == Unqual!TimeZone);
public enum isDateTimeArrayType(T) = is(T == Unqual!(Date[])) || is(T == Unqual!(DateTime[])) || is(T == Unqual!(SysTime[])) || is(T == Unqual!(TimeOfDay[])) || is(T == Unqual!(Duration[])) || is(T == Unqual!(TimeZone[]));

enum string[] excludedMethods = ["toHash", "opEquals", "opCmp", "factory", "__ctor"];

public struct LibraryName {
    string value;
}

public struct RootNamespace {
    string value;
}

public struct OutputFileName {
    string value;
}

package struct WrapAggregate {
    public string name;

    public WrapMethod[] methods;
    public WrapField[] fields;
    public WrapProperty[] properties;
}

public struct WrapConstructor {
    public WrapParameter[] parameters;
}

package string[] getWrapConstructors(T)()
if (is(T == class) || is(T == struct)){
    import std.traits : isFunction;
    import std.algorithm : among, uniq;

    string[] methods;

    static if(hasMember!(T, "__ctor") && __traits(getProtection, __traits(getMember, T, "__ctor")).among("export", "public")) {
        foreach(oc, mo; __traits(getOverloads, T, "__ctor")) {
            if(isFunction!mo && __traits(getProtection, mo).among("export", "public")) {
                methods ~= m;
            }
        }
    }

    return methods.uniq();
}

package struct WrapMethod {
    public string name;

    public string csharpReturnType;
    public string csharpReturnInterfaceType;
    public string dlangReturnInterfaceType;

    public WrapParameter[] parameters;

    public this(string name, string csharpReturnType, string csharpReturnInterfaceType, string dlangReturnInterfaceType) {
        this.name = name;
        this.csharpReturnType = csharpReturnType;
        this.csharpReturnInterfaceType = csharpReturnInterfaceType;
        this.dlangReturnInterfaceType = dlangReturnInterfaceType;
    }
}

package struct WrapParameter {
    public string name;

    public string csharpType;
    public string csharpInterfaceType;
    public string dlangInterfaceType;

    public this(string name, string csharpType, string csharpInterfaceType, string dlangInterfaceType) {
        this.name = name;
        this.csharpType = csharpType;
        this.csharpInterfaceType = csharpInterfaceType;
        this.dlangInterfaceType = dlangInterfaceType;
    }
}
 
package string[] getWrapMethods(T)(string[] exclude)
if (is(T == class) || is(T == interface) || is(T == struct)){
    import std.traits : isFunction, functionAttributes, FunctionAttribute;
    import std.algorithm : among, uniq;

    string[] methods;
    exclude ~= excludedMethods;

    foreach(m; __traits(allMembers, T)) {
        if (m.among(exclude)) {
            continue;
        }

        if (is(typeof(__traits(getMember, T, m)))) {
            foreach(oc, mo; __traits(getOverloads, T, m)) {
                if(isFunction!mo && __traits(getProtection, mo).among("export", "public") && !cast(bool)(functionAttributes!mo & FunctionAttribute.property)) {
                    methods ~= m;
                }
            }
        }
    }

    return methods.uniq();
}

package struct WrapField {
    public string name;
    public size_t memorySize;
    public bool wrap;

    public string csharpPropertyType;
    public string csharpInterfaceType;
    public string dlangInterfaceType;

    public this(size_t memorySize, string name, bool wrap, string csharpPropertyType, string csharpInterfaceType, string dlangInterfaceType) {
        this.memorySize = memorySize;
        this.name = name;
        this.wrap = wrap;
        this.csharpPropertyType = csharpPropertyType;
        this.csharpInterfaceType = csharpInterfaceType;
        this.dlangInterfaceType = dlangInterfaceType;
    }
}

package WrapField[] getWrapFields(T)(string[] exclude)
if (is(T == class) || is(T == interface) || is(T == struct)){
    import std.traits : fullyQualifiedName, Fields, FieldNameTuple;
    import std.algorithm : among, uniq;

    alias fieldTypes = Fields!T;
    alias fieldNames = FieldNameTuple!T;
    WrapField[] fields;

    foreach(fc, ft; fieldTypes) {
        if (!fieldNames[fc].among(exclude)) {
            alias fqn = fullyQualifiedName!ft;
            fields ~= WrapField(ft.sizeof, fieldNames[fc], __traits(getProtection, ft).among("export", "public"), getCSharpInterfaceType(fqn), getCSharpType(fqn), getDLangInterfaceType(fqn));
        }
    }

    return fields;
}

package struct WrapProperty {
    public string name;
    public bool getter;
    public bool setter;

    public string csharpPropertyType;
    public string csharpInterfaceType;
    public string dlangInterfaceType;

    public this(string name, bool getter, bool setter, string csharpInterfaceType, string csharpPropertyType, string dlangInterfaceType) {
        this.name = name;
        this.getter = getter;
        this.setter = setter;
        this.csharpPropertyType = csharpPropertyType;
        this.csharpInterfaceType = csharpInterfaceType;
        this.dlangInterfaceType = dlangInterfaceType;
    }
}

package WrapProperty[] getWrapProperties(T)(string[] exclude)
if (is(T == class) || is(T == interface) || is(T == struct)){
    import std.traits : isArray, fullyQualifiedName, functionAttributes, FunctionAttribute, ReturnType, Parameters;

    exclude ~= excludedMethods ~ "__ctor";
    WrapProperty[] properties;

    foreach(m; __traits(allMembers, T)) {
        if (m.among(exclude)) {
            continue;
        }

        if (is(typeof(__traits(getMember, T, m)))) {
            const olc = __traits(getOverloads, T, m).length;
            if(olc > 0 && olc <= 2) {
                bool isProperty = false;
                bool propertyGet = false;
                bool propertySet = false;
                foreach(mo; __traits(getOverloads, T, m)) {
                    if (cast(bool)(functionAttributes!mo & FunctionAttribute.property)) {
                        isProperty = true;
                        alias returnType = ReturnType!mo;
                        alias paramTypes = Parameters!mo;
                        if (paramTypes.length == 0) {
                            propertyGet = true;
                        } else {
                            propertySet = true;
                        }
                    }
                }

                if (isProperty) {
                    alias returnType = ReturnType!(__traits(getOverloads, T, m)[0]);
                    alias fqn = fullyQualifiedName!returnType;
                    properties ~= WrapProperty(m, propertyGet, propertySet, getCSharpInterfaceType(fqn), getCSharpType(fqn), getDLangInterfaceType(fqn));
                }
            }
        }
    }
}

package string getCSharpName(string dlangName) {
    import autowrap.csharp.common : camelToPascalCase;
    import std.algorithm : map;
    import std.string : split;
    import std.array : join;
    return dlangName.split(".").map!camelToPascalCase.join(".");
}

package string getCSharpInterfaceType(string type) {
    if (type[$-2..$] == "[]") return "slice";

    switch(type) {
        //Types that require special marshalling types
        case voidTypeString: return "void";
        case stringTypeString: return "slice";
        case wstringTypeString: return "slice";
        case dstringTypeString: return "slice";
        case sysTimeTypeString: return "datetime";
        case dateTimeTypeString: return "datetime";
        case timeOfDayTypeString: return "datetime";
        case dateTypeString: return "datetime";
        case durationTypeString: return "datetime";
        case boolTypeString: return "bool";

        //Types that can be marshalled by default
        case charTypeString: return "byte";
        case wcharTypeString: return "char";
        case dcharTypeString: return "uint";
        case ubyteTypeString: return "byte";
        case byteTypeString: return "sbyte";
        case ushortTypeString: return "ushort";
        case shortTypeString: return "short";
        case uintTypeString: return "uint";
        case intTypeString: return "int";
        case ulongTypeString: return "ulong";
        case longTypeString: return "long";
        case floatTypeString: return "float";
        case doubleTypeString: return "double";
        default: return getCSharpName(type);
    }
}

package string getCSharpType(string type) {
    if (type[$-2..$] == "[]") type = type[0..$-2];

    switch (type) {
        //Types that require special marshalling types
        case voidTypeString: return "void";
        case stringTypeString: return "string";
        case wstringTypeString: return "string";
        case dstringTypeString: return "string";
        case sysTimeTypeString: return "DateTimeOffset";
        case dateTimeTypeString: return "DateTime";
        case timeOfDayTypeString: return "DateTime";
        case dateTypeString: return "DateTime";
        case durationTypeString: return "TimeSpan";
        case boolTypeString: return "bool";

        //Types that can be marshalled by default
        case charTypeString: return "byte";
        case wcharTypeString: return "char";
        case dcharTypeString: return "uint";
        case ubyteTypeString: return "byte";
        case byteTypeString: return "sbyte";
        case ushortTypeString: return "ushort";
        case shortTypeString: return "short";
        case uintTypeString: return "uint";
        case intTypeString: return "int";
        case ulongTypeString: return "ulong";
        case longTypeString: return "long";
        case floatTypeString: return "float";
        case doubleTypeString: return "double";
        default: return getCSharpName(type);
    }
}

package string getDLangInterfaceType(T)() {
    import std.traits : fullyQualifiedName;
    import std.datetime : DateTime, SysTime, Date, TimeOfDay, Duration;
    if (isDateTimeType!T) {
        return "datetime";
    } else if (isDateTimeArrayType!T) {
        return "datetime[]";
    } else {
        return fullyQualifiedName!T;
    }
}

package string getDLangInterfaceName(string moduleName, string aggName, string funcName) {
    import std.algorithm : map;
    import std.string : split;
    import std.array : join;

    string name = "autowrap_csharp_";
    name ~= moduleName.split(".").map!camelToPascalCase.join("_");

    if (aggName != string.init) {
        name ~= camelToPascalCase(aggName) ~ "_";
    }
    name ~= camelToPascalCase(funcName);
    return name;
}

package string getDLangInterfaceName(string fqn, string funcName) {
    import std.algorithm : map;
    import std.string : split;
    import std.array : join;
    string name = "autowrap_csharp_";

    name ~= fqn.split(".").map!camelToPascalCase.join("_");
    name ~= camelToPascalCase(funcName);
    return name;
}

package string getDLangSliceInterfaceName(string fqn, string funcName) {
    import std.algorithm : map, among;
    import std.string : split;
    import std.array : join;

    string name = "autowrap_csharp_slice_";

    if (fqn.among("core.time.Duration", "std.datetime.systime.SysTime", "std.datetime.date.DateTime", "autowrap.csharp.dlang.datetime")) {
        fqn = "Autowrap_Csharp_Boilerplate_Datetime";
    }

    name ~= fqn.split(".").map!camelToPascalCase.join("_");
    name ~= camelToPascalCase(funcName);
    return name;
}

public string camelToPascalCase(string camel) {
    import std.uni : toUpper;
    import std.conv : to;
    return to!string(camel[0].toUpper) ~ camel[1..$];
}
