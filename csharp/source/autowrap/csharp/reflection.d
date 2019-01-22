module autowrap.csharp.reflection;

public enum Visibility {
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

    public immutable Visibility visibility;
    public immutable ParameterDefinition[] parameters;

    public immutable TypeInfo returnType;
    public immutable bool isRefReturn;
    public immutable bool isAutoReturn;
    public immutable bool isInoutReturn;

    public immutable bool isNothrow;
    public immutable bool isPure;
    public immutable bool isNogc;
    public immutable bool isSafe;
    public immutable bool isTrusted;
    public immutable bool isSystem;
}

public immutable struct StructDefinition {
    public immutable string name;
    public immutable string fqn;
    public immutable TypeInfo_Struct type;

    public immutable Visibility visibility;
    public immutable bool isShared;
    public immutable bool isConst;
    public immutable bool isImmutable;
}

public immutable struct InterfaceDefinition {
    public immutable string name;
    public immutable string fqn;
    public immutable TypeInfo_Interface type;

    public immutable Visibility visibility;
    public immutable bool isShared;
    public immutable bool isConst;
    public immutable bool isImmutable;
}

public immutable struct ClassDefinition {
    public immutable string name;
    public immutable string fqn;
    public immutable TypeInfo_Class type;

    public immutable Visibility visibility;
    public immutable bool isShared;
    public immutable bool isConst;
    public immutable bool isImmutable;
    public immutable bool isAbstract;
    public immutable bool isFinal;
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
}

