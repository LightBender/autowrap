module autowrap.csharp.reflection;

import std.algorithm : among;
public import std.meta : Unqual;

public ModuleDefinition testModule = reflectModule!"autowrap.csharp.reflection";
public StructDefinition testStruct = reflectStruct!StructDefinition;
public EnumDefinition testEnum = reflectEnum!Protection;

public enum Protection {
    Export,
    Public,
    Package,
    Protected,
    Private
}

public immutable struct ModuleDefinition {
    public immutable string name;
    public immutable string fqn;

    public immutable FunctionDefinition[] functions;
    public immutable EnumDefinition[] enumerations;
    public immutable StructDefinition[] structs;
    public immutable InterfaceDefinition[] interfaces;
    public immutable ClassDefinition[] classes;

    private this(const string fqn, const string name, immutable(FunctionDefinition)[] functions, immutable(EnumDefinition)[] enumerations, immutable(StructDefinition)[] structs, immutable(InterfaceDefinition)[] interfaces, immutable(ClassDefinition)[] classes) {
        this.fqn = fqn;
        this.name = name;

        this.functions = cast(immutable)functions;
        this.enumerations = cast(immutable)enumerations;
        this.structs = cast(immutable)structs;
        this.interfaces = cast(immutable)interfaces;
        this.classes = cast(immutable)classes;
    }
}

public immutable struct EnumDefinition {
    public immutable string fqn;
    public immutable string name;
    public immutable TypeInfo_Enum type;
    public immutable TypeInfo baseType;
    public immutable Protection protection;
    public immutable EnumValue[] values;

    private this(const string fqn, const string name, const TypeInfo_Enum type, const TypeInfo baseType, const Protection protection, immutable(EnumValue)[] values) {
        this.fqn = fqn;
        this.name = name;
        this.type = cast(immutable)type;
        this.baseType = cast(immutable)baseType;
        this.protection = protection;
        this.values = cast(immutable)values;
    }
}

public immutable struct EnumValue {
    public immutable string name;
    public immutable string value;

    private this(const string name, const string value) {
        this.name = name;
        this.value = value;
    }
}

public immutable struct FunctionDefinition {
    public immutable string name;
    public immutable string fqn;

    public immutable ParameterDefinition[] parameters;

    public immutable TypeInfo returnType;
    public immutable bool isRef;
    public immutable bool isShared;
    public immutable bool isConst;
    public immutable bool isImmutable;
    public immutable bool isInout;

    public immutable Protection protection;
    public immutable bool isProperty;
    public immutable bool isNothrow;
    public immutable bool isPure;
    public immutable bool isNogc;
    public immutable bool isSafe;
    public immutable bool isTrusted;
    public immutable bool isSystem;

    private this(const string fqn, const string name, immutable(ParameterDefinition)[] parameters, const TypeInfo returnType, const bool isRef, const bool isShared, const bool isConst, const bool isImmutable, const bool isInout, const Protection protection, const bool isProperty, const bool isNothrow, const bool isPure, const bool isNogc, const bool isSafe, const bool isTrusted, const bool isSystem) {
        this.name = cast(immutable)name;
        this.fqn = cast(immutable)fqn;
        this.parameters = cast(immutable)parameters;
        this.isRef = cast(immutable)isRef;
        this.isShared = cast(immutable)isShared;
        this.isConst = cast(immutable)isConst;
        this.isImmutable = cast(immutable)isImmutable;
        this.isInout = cast(immutable)isInout;
        this.protection = cast(immutable)protection;
        this.isProperty = cast(immutable)isProperty;
        this.isNothrow = cast(immutable)isNothrow;
        this.isPure = cast(immutable)isPure;
        this.isNogc = cast(immutable)isNogc;
        this.isSafe = cast(immutable)isSafe;
        this.isTrusted = cast(immutable)isTrusted;
        this.isSystem = cast(immutable)isSystem;
    }
}

public immutable struct ParameterDefinition {
    public immutable string name;
    public immutable TypeInfo type;

    public immutable bool isShared;
    public immutable bool isConst;
    public immutable bool isImmutable;

    public immutable bool isLazy;
    public immutable bool isIn;
    public immutable bool isOut;
    public immutable bool isRef;
    public immutable bool isInout;
    public immutable bool isScope;
    public immutable bool isReturn;

    private immutable this(string name, TypeInfo type, bool isShared, bool isConst, bool isImmutable, bool isLazy, bool isIn, bool isOut, bool isRef, bool isInout, bool isScope, bool isReturn) {
        this.name = cast(immutable)name;
        this.type = cast(immutable)type;

        this.isShared = cast(immutable)isShared;
        this.isConst = cast(immutable)isConst;
        this.isImmutable = cast(immutable)isImmutable;

        this.isLazy = cast(immutable)isImmutable;
        this.isIn = cast(immutable)isIn;
        this.isOut = cast(immutable)isOut;
        this.isRef = cast(immutable)isRef;
        this.isInout = cast(immutable)isInout;
        this.isScope = cast(immutable)isScope;
        this.isReturn = cast(immutable)isReturn;
    }
}

public immutable struct StructDefinition {
    public immutable string name;
    public immutable string fqn;
    public immutable TypeInfo_Struct type;

    public immutable Protection protection;
    public immutable bool isShared;
    public immutable bool isConst;
    public immutable bool isImmutable;

    public immutable FieldDefinition[] fields;
    public immutable FunctionDefinition[] methods;

    private immutable this(
        const string fqn,
        const string name,
        const TypeInfo_Struct type,
        const Protection protection,
        const bool isShared,
        const bool isConst,
        const bool isImmutable, 
        immutable(FieldDefinition)[] fields,
        immutable(FunctionDefinition)[] methods)
    {
        this.fqn = cast(immutable)fqn;
        this.name = cast(immutable)name;
        this.type = cast(immutable)type;
        this.protection = cast(immutable)protection;
        this.isShared = cast(immutable)isShared;
        this.isConst = cast(immutable)isConst;
        this.isImmutable = cast(immutable)isImmutable;
        this.fields = cast(immutable)fields;
        this.methods = cast(immutable)methods;
    }
}

public immutable struct InterfaceDefinition {
    public immutable string name;
    public immutable string fqn;
    public immutable TypeInfo_Interface type;

    public immutable Protection protection;
    public immutable bool isShared;
    public immutable bool isConst;
    public immutable bool isImmutable;
}

public immutable struct ClassDefinition {
    public immutable string name;
    public immutable string fqn;
    public immutable TypeInfo_Class type;

    public immutable Protection protection;
    public immutable bool isShared;
    public immutable bool isConst;
    public immutable bool isImmutable;
    public immutable bool isAbstract;
    public immutable bool isFinal;
}

public immutable struct FieldDefinition {
    public immutable string name;
    public immutable TypeInfo type;

    public immutable Protection protection;
    public immutable bool isShared;
    public immutable bool isConst;
    public immutable bool isImmutable;

    public immutable size_t size;
    public immutable size_t offset;

    private immutable this(string name, TypeInfo type, Protection protection, bool isShared, bool isConst, bool isImmutable, size_t size, size_t offset) {
        this.name = cast(immutable)name;
        this.type = cast(immutable)type;
        this.protection = cast(immutable)protection;
        this.isShared = cast(immutable)isShared;
        this.isConst = cast(immutable)isConst;
        this.isImmutable = cast(immutable)isImmutable;
        this.size = cast(immutable)size;
        this.offset = cast(immutable)offset;
    }
}

public ModuleDefinition reflectModule(string module_)() {
    import std.traits : fullyQualifiedName, isFunction;

    mixin(`import dmodule = ` ~ module_ ~ `;`);
    alias members = __traits(allMembers, dmodule);
    const string fqn = fullyQualifiedName!dmodule;
    const string name = __traits(identifier, dmodule);

    FunctionDefinition[] functions;
    EnumDefinition[] enumerations;
    StructDefinition[] structs;

    static foreach(m; members) {
        static if(isFunction!m) {
            functions ~= reflectFunction!m;
        } else static if (is(m == enum)) {
            enumerations ~= reflectEnum!m;
        } else static if (is(m == struct)) {
            structs ~= reflectStruct!m;
        }
    }

    return ModuleDefinition(fqn, name, functions, enumerations, structs, null, null);
}

public EnumDefinition reflectEnum(T)() if(is(Unqual!T == enum)) {
    import std.traits : fullyQualifiedName, OriginalType, EnumMembers;
    import std.conv : to;

    const string fqn = fullyQualifiedName!T;
    const string name = __traits(identifier, T);
    const TypeInfo_Enum type = typeid(Unqual!T);
    const TypeInfo baseType = typeid(OriginalType!T);
    const Protection protection = getProtection(__traits(getProtection, T));

    alias memberNames = EnumMembers!T;
    auto memberValues = cast(OriginalType!T[])[EnumMembers!T];
    EnumValue[] values;
    foreach(ec, em; memberNames) {
        values ~= EnumValue(__traits(identifier, em), to!string(memberValues[ec]));
    }

    return EnumDefinition(fqn, name, type, baseType, protection, values);
}

public StructDefinition reflectStruct(T)() if(is(Unqual!T == struct)) {
    import std.traits : fullyQualifiedName, isFunction, Fields, FieldNameTuple;
    import std.conv : to;

    const string fqn = fullyQualifiedName!T;
    const string name = __traits(identifier, T);
    const TypeInfo_Struct type = typeid(Unqual!T);
    const Protection protection = getProtection(__traits(getProtection, T));
    const bool isShared = is(T == shared);
    const bool isConst = is(T == const);
    const bool isImmutable = is(T == immutable);

    FunctionDefinition[] functions;
    alias members = __traits(allMembers, T);
    foreach(m; members) {
        if (isFunction!m || __traits(identifier, m) == "__ctor") {
            foreach(o; __traits(getOverloads, T, m)) {
                functions ~= reflectFunction!o;
            }
        }
    }

    FieldDefinition[] fields;
    alias fieldTypes = Fields!T;
    alias fieldNames = FieldNameTuple!T;
    foreach(fc, fn; fieldNames) {
        alias ft = fieldTypes[fc];
        mixin("const size_t offset = " ~ fullyQualifiedName!T ~ "." ~ fn ~ ".offsetof;");
        mixin("const Protection fp = getProtection(__traits(getProtection, " ~ fullyQualifiedName!T ~ "." ~ fn ~ "));");
        fields ~= FieldDefinition(fn, typeid(ft), fp, is(ft == shared), is(ft == const), is(ft == immutable), ft.sizeof, offset);
    }

    return StructDefinition(fqn, name, type, protection, isShared, isConst, isImmutable, fields, functions);
}

public FieldDefinition reflectField(T, string N)() if(is(Unqual!T == struct) || is(Unqual!T == class)) {
    import std.traits: fullyQualifiedName;
    alias field = __traits(getMember, T, N);
    const string id = __traits(identifier, field);
    auto type = typeid(field);
    const Protection protection = getProtection!field;
    const bool isShared = is(pt == shared);
    const bool isConst = is(pt == const);
    const bool isImmutable = is(pt == immutable);
    mixin("const size_t offset = " ~ fullyQualifiedName!T ~ "." ~ N ~ ".offsetof;");
    const size_t size = field.sizeof;

    return FieldDefinition(id, type, protection, isShared, isConst, isImmutable, size, offset);
}

public FunctionDefinition reflectFunction(alias T)() {
    import std.traits: fullyQualifiedName, ReturnType, Parameters, ParameterIdentifierTuple, ParameterStorageClass, ParameterStorageClassTuple;

    const string name = __traits(identifier, T);
    const string fqn = fullyQualifiedName!T;
    const auto type = typeid(ReturnType!T);
    const Protection protection = getProtection(__traits(getProtection, T));
    const bool isShared = "shared".among(__traits(getFunctionAttributes, T)) != 0;
    const bool isConst = "const".among(__traits(getFunctionAttributes, T)) != 0;
    const bool isImmutable = "immutable".among(__traits(getFunctionAttributes, T)) != 0;
    const bool isInout = "inout".among(__traits(getFunctionAttributes, T)) != 0;
    const bool isPure = "pure".among(__traits(getFunctionAttributes, T)) != 0;
    const bool isRef = "ref".among(__traits(getFunctionAttributes, T)) != 0;
    const bool isNothrow = "nothrow".among(__traits(getFunctionAttributes, T)) != 0;
    const bool isNogc = "@nogc".among(__traits(getFunctionAttributes, T)) != 0;
    const bool isProperty = "@property".among(__traits(getFunctionAttributes, T)) != 0;
    const bool isSafe = "@safe".among(__traits(getFunctionAttributes, T)) != 0;
    const bool isTrusted = "@trusted".among(__traits(getFunctionAttributes, T)) != 0;
    const bool isSystem = "@system".among(__traits(getFunctionAttributes, T)) != 0;

    alias paramTypes = Parameters!T;
    alias paramNames = ParameterIdentifierTuple!T;
    alias paramStorage = ParameterStorageClassTuple!T;

    ParameterDefinition[] parameters;
    foreach(pc, pt; paramTypes) {
        const bool isParamShared = is(pt == shared);
        const bool isParamConst = is(pt == const);
        const bool isParamImmutable = is(pt == immutable);
        const bool isParamInout = is(pt == inout);
        const bool isParamLazy = paramStorage[pc] == ParameterStorageClass.lazy_;
        const bool isParamOut = paramStorage[pc] == ParameterStorageClass.out_;
        const bool isParamRef = paramStorage[pc] == ParameterStorageClass.ref_;
        const bool isParamScope = paramStorage[pc] == ParameterStorageClass.scope_;
        const bool isParamReturn = paramStorage[pc] == ParameterStorageClass.return_;
        parameters ~= ParameterDefinition(paramNames[pc], typeid(pt), isParamShared, isParamConst, isParamImmutable, isParamLazy, isParamConst, isParamOut, isParamRef, isParamInout, isParamScope, isParamReturn);
    }

    return FunctionDefinition(fqn, name, parameters, type, isRef, isShared, isConst, isImmutable, isInout, protection, isProperty, isNothrow, isPure, isNogc, isSafe, isTrusted, isSystem);
}

private Protection getProtection(string prot) {
    if (prot == "export") return Protection.Export;
    if (prot == "public") return Protection.Public;
    if (prot == "package") return Protection.Package;
    if (prot == "protected") return Protection.Protected;
    return Protection.Private;
}