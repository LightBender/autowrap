module autowrap.csharp.reflection;

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
    public immutable StructDefinition[] structs;
    public immutable InterfaceDefinition[] interfaces;
    public immutable ClassDefinition[] classes;
}

public immutable struct FunctionDefinition {
    public immutable string name;
    public immutable string fqn;

    public immutable Protection protection;
    public immutable ParameterDefinition[] parameters;

    public immutable TypeInfo returnType;
    public immutable bool isRefReturn;
    public immutable bool isAutoReturn;
    public immutable bool isInoutReturn;

    public immutable bool isShared;
    public immutable bool isConst;
    public immutable bool isImmutable;

    public immutable bool isNothrow;
    public immutable bool isPure;
    public immutable bool isNogc;
    public immutable bool isSafe;
    public immutable bool isTrusted;
    public immutable bool isSystem;
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

    private immutable this(string fqn, string name, TypeInfo_Struct type, Protection protection, bool isShared, bool isConst, bool isImmutable, FieldDefinition[] fields, FunctionDefinition[] methods) {
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

    public immutable this(string name, TypeInfo type, Protection protection, bool isShared, bool isConst, bool isImmutable, size_t size, size_t offset) {
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

public StructDefinition reflectStruct(T)() if(is(T == struct)) {
    import std.traits : fullyQualifiedName;
    import std.algorithm : among;

    alias fqn = fullyQualifiedName!T;
    alias name = __traits(identifier, T);
    auto type = typeid(T);
    const Protection protection = getProtection!T;
}

public FieldDefinition reflectField(T)() {
    alias name = __traits(identifier, T);
    auto type = typeid(T);
    const Protection protection = getProtection!T;
    const bool isShared = "shared".among(__traits(getFunctionAttributes, T));
    const bool isConst = "const".among(__traits(getFunctionAttributes, T));
    const bool isImmutable = "immutable".among(__traits(getFunctionAttributes, T));
    const size_t offset = T.offsetof;
    const size_t size = T.sizeof;

    return new FieldDefinition(name, type, protection, isShared, isConst, isImmutable, size, offset);
}

public FunctionDefinition reflectFunction(T)() {
    import std.traits: ReturnType, Parameters, ParameterIdentifierTuple;

    alias name = __traits(identifier, T);
    const auto type = ReturnType!T;
    const Protection protection = getProtection!T;
    const bool isShared = "shared".among(__traits(getFunctionAttributes, T));
    const bool isConst = "const".among(__traits(getFunctionAttributes, T));
    const bool isImmutable = "immutable".among(__traits(getFunctionAttributes, T));

    alias paramTypes = Parameters!T;
    alias paramNames = ParameterIdentifierTuple!T;
}

private Protection getProtection(T)() {
    const bool isExportProtection = "export".among(__traits(getProtection, T));
    const bool isPublicProtection = "public".among(__traits(getProtection, T));
    const bool isPackageProtection = "package".among(__traits(getProtection, T));
    const bool isProtectedProtection = "protected".among(__traits(getProtection, T));

    if (isExportProtection) return Protection.Export;
    if (isPublicProtection) return Protection.Public;
    if (isPackageProtection) return Protection.Package;
    if (isProtectedProtection) return Protection.Protected;
    return Protection.Private;
}