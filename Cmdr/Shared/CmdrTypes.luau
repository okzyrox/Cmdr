--/ Cmdr Type index

export type CmdrServer = {
    --- Refers to the current command Registry.
    Registry: Registry,
    --- Refers to the current command Dispatcher.
    Dispatcher: Dispatcher,
    --- Refers to a table containing many useful utility functions.
    Util: Util,

    --[=[
        Registers a command definition and its server equivalent. Handles replicating the definition to the client.

        **This only works when running on the Server.**
    ]=]
    RegisterCommandsIn: (self: CmdrServer, container: Instance, filter: ((CommandDefinition) -> boolean)?) -> (),

    --[=[
        Registers all the types from within the given container, on both the server and client.

        **This only works when running on the Server.**
    ]=]
    RegisterTypesIn: (self: CmdrServer, container: Instance) -> (),

    --[=[
        Registers a hook on the current realm (server/client). 
        
        This should probably be ran on the server or in a hook module script, but can also work on the client.

        Hooks run in order of priority from lowest (running first) to highest.
    ]=]
    RegisterHooksIn: (self: CmdrServer, container: Instance) -> (),
    
    --[=[
        Registers the default commands on both the server and client.

        The optional arrayOrFunc parameter can be provided with:

        1. an array of strings — this will limit registration to only commands which have their `Group` property set to this
        2. a function which takes in a `CommandDefinition` and returns a boolean — only if true is returned will the command be registered
        
        **This only works when running on the Server.**
    ]=]
    RegisterDefaultCommands: (self: CmdrServer, arrayOrFunc: {string} | ((CommandDefinition) -> boolean)?) -> (),
}


export type CmdrClient = {
    --- Refers to the current command Registry.
    Registry: Registry,
    
    --- Refers to the current command Dispatcher.
    Dispatcher: Dispatcher,
    
    --- Refers to a table containing many useful utility functions.
    Util: Util,
    
    --- Whether or not Cmdr is enabled (will show via the defined activation keys). Use `CmdrClient:SetEnabled` to change.
    Enabled: boolean,
    
    --- The current place name, displayed on the interface. Use `CmdrClient:SetPlaceName` to change.
    PlaceName: string,
    
    --- The list of key codes that will show or hide Cmdr. Use `CmdrClient:SetActivationKeys` to change.
    ActivationKeys: {[Enum.KeyCode]: true},

    --- Sets the key codes that will used to show or hide Cmdr.
    SetActivationKeys: (self: CmdrClient, keys: {Enum.KeyCode}) -> (),

    --- Sets the place name label on the interface. This is useful for a quick way to tell what game you're playing in a universe game.
    SetPlaceName: (self: CmdrClient, name: string) -> (),

    --[=[
        Sets whether or not Cmdr can be shown via the defined activation keys. 
        
        Useful for when you want users to opt-in to show the console, for instance in a settings menu.
    ]=]
    SetEnabled: (self: CmdrClient, enabled: boolean) -> (),

    --- Sets if activation will free the mouse.
    SetActivationUnlocksMouse: (self: CmdrClient, enabled: boolean) -> (),

    --- Shows the Cmdr window. Does nothing if Cmdr isn't enabled.
    Show: (self: CmdrClient) -> (),

    --- Hides the Cmdr window.
    Hide: (self: CmdrClient) -> (),

    --- Toggles the Cmdr window. Does nothing if Cmdr isn't enabled.
    Toggle: (self: CmdrClient) -> (),

    --[=[
        Enables the "Mash to open" feature. 
        
        This feature, when enabled, requires the activation key to be pressed 5 times within a second to enable Cmdr. 
        
        This may be helpful to guard against mispresses from opening the window, for example. 
    ]=]
    SetMashToEnable: (self: CmdrClient, enabled: boolean) -> (),

    --- Sets the hide on 'lost focus' feature. This feature, which is enabled by default, will cause Cmdr to `Hide` when the user clicks off the window. 
    SetHideOnLostFocus: (self: CmdrClient, enabled: boolean) -> (),
    
    --- Sets the network event handler for a certain event type by name.
    HandleEvent: (self: CmdrClient, name: string, callback: (...any) -> ()) -> ()
}

export type Registry = {
    --- A reference to Cmdr. This may either be the server or client version of Cmdr depending on where the code is running
    Cmdr: CmdrClient | CmdrServer,

    --- Registers a type on the current realm (server/client), this function should be called from within the type definition ModuleScript.
    RegisterType: (self: Registry, name: string, typeObject: TypeDefinition<any>) -> (),
    
    --[=[
        Registers a Prefixed Union Type string on the current realm (server/client), this function should be called from within the type definition ModuleScript.

        If there are already type prefixes for the given type name, they will be concatenated. This allows you to add prefixes to default types, like `players`.
    ]=]
    RegisterTypePrefix: (self: Registry, name: string, union: string) -> (),
    
    --[=[
        Allows you to register a name which will be expanded into a longer type which can be used as a command argument type. 
        
        For example, if you register the alias `stringOrNumber` it could be interpreted as `string # number` when used. 
    ]=]
    RegisterTypeAlias: (self: Registry, name: string, alias: string) -> (),
    
    --[=[
        Registers all the types from within the given container, on both the server and client.

        **This only works when running on the Server.**
    ]=]
    RegisterTypesIn: (self: Registry, container: Instance) -> (),
    
    --[=[
        Registers a hook on the current realm (server/client). 
        
        This should probably be ran on the server or in a hook module script, but can also work on the client.

        Hooks run in order of priority from lowest (running first) to highest.
    ]=]
    RegisterHook: (
        self: Registry,
        callback: (CommandContext) -> string?,
        priority: number?
    ) -> (),

    --[=[
        Registers all hooks from within a container on both the server and client. 
        
        If you want to add a hook only on the server or client – e.g. for logging – then you should use the `Register:RegisterHook` method instead. 

        **This only works when running on the Server.**
    ]=]
    RegisterHooksIn: (self: Registry, container: Instance) -> (),

    --[=[
        Registers a command definition and its server equivalent. Handles replicating the definition to the client.

        **This only works when running on the Server.**
    ]=]
    RegisterCommand: (
        self: Registry, 
        commandScript: ModuleScript, 
        commandServerScript: ModuleScript?,
        filter: ((CommandDefinition) -> boolean)?
    ) -> (),

    --[=[
        Registers all commands from within a container on both the server and client.

        Module scripts which include Server in their name will not be sent to the client.

        **This only works when running on the Server.**
    ]=]
    RegisterCommandsIn: (
        self: Registry, 
        container: Instance, 
        filter: ((CommandDefinition) -> boolean)?
    ) -> (),

    --[=[
        Registers the default commands on both the server and client.

        The optional arrayOrFunc parameter can be provided with:

        1. an array of strings — this will limit registration to only commands which have their `Group` property set to this
        2. a function which takes in a `CommandDefinition` and returns a boolean — only if true is returned will the command be registered
        
        **This only works when running on the Server.**
    ]=]
    RegisterDefaultCommands: (
        self: Registry,
        arrayOrFunc: {string} | ((CommandDefinition) -> boolean)?
    ) -> (),

    --- Returns the `CommandDefinition` from the given name, or `nil` if no command is found. Command aliases are also accepted.
    GetCommand: (self: Registry, name: string) -> CommandDefinition?,
    
    --- Returns an array of all registers commands, not including aliases.
    GetCommands: (self: Registry) -> {CommandDefinition},
    
    --- Returns an array of containing the names of all registered commands, not including aliases.
    GetCommandNames: (self: Registry) -> {string},
    
    --- Returns an array of containing the names of all registered types, not including aliases.
    GetTypeNames: (self: Registry) -> {string},
    
    --- Returns the type definition from the given name, or `nil` if no argument is found.
    GetType: (self: Registry, name: string) -> TypeDefinition<any>?,
    
    --- Returns a type name taking aliases into account. If there is no alias, the name parameter is simply returned as a pass through.
    GetTypeName: (self: Registry, name: string) -> TypeDefinition<any> | string,
    
    --[=[
        Returns a table saved with the given name. 
        
        Always returns the same table on subsequent calls. 
        
        Useful for commands that require persistent state, like bind or ban. 
        
        This is the same as `CommandContext:GetStore`. 
    ]=]
    GetStore: (self: Registry, name: string) -> {},
    
}

export type Dispatcher = {
    --- A reference to Cmdr. This may either be the server or client version of Cmdr depending on where the code is running.
    Cmdr: CmdrClient | CmdrServer,
    
    --- The registry associated with this dispatcher.
    Registry: Registry,

    --[=[
        Runs a command as the given player. 
        
        `Executor` is optional when running on the client.

        If `options.Data` is given, it will be available on the server with `CommandContext:GetData`

        If `options.IsHuman` is `true` and this function is called on the client, then the `text` will be inserted into the window history.
    ]=]
    EvaluateAndRun: (
        text: string,
        executor: Player?,
        options: {
            Data: any?,
            IsHuman: boolean?
        }?
    ) -> string,

    --[=[
        Invokes a command programmatically as the local player. 
        
        Accepts a variable number of arguments, which are all joined with spaces before being run; the command should be the first argument. 
        
        This function will raise an error if any validations occur, since it's only for hard-coded (or generated) commands. 

        **This only works when running on the Client.**
    ]=]
    Run: (self: Dispatcher, ...string) -> string,

    --[=[
        Returns an array of the user's command history. 
        
        Most recent commands are inserted at the end of the array.

        **This only works when running on the Client.**
    ]=]
    GetHistory: (self: Dispatcher) -> {string},
}

export type HookType = "BeforeRun" | "AfterRun"

export type ArgumentContext = {
    --- The command that this argument belongs to.
    Command: CommandContext,
    
    --- The type definition for this argument.
    Type: TypeDefinition<any>,
    
    --- The name of this argument, shown on the autocomplete interface.
    Name: string,
    
    --- The raw argument definition.
    Object: ArgumentDefinition,
    
    --- Whether or not this argument was required.
    Required: boolean,
    
    --- The player that ran the command that this argument belongs to.
    Executor: Player,
    
    --- The raw, unparsed value for this argument.
    RawValue: string,
    
    --- An array of strings representing the values in a comma-separated list, if applicable.
    RawSegments: {string},
    
    --- The prefix used in this argument (like % in %Team). Empty string if no prefix was used. Refer to  Prefixed Union Types for more details.
    Prefix: string,

    --- Returns the transformed value from this argument. Refer to Cmdr Types.
    GetTransformedValue: (ctx: ArgumentContext, segment: number) -> ...any,
    
    --- Returns the parsed (final) value for this argument.
    GetValue: (ctx: ArgumentContext) -> any,
}

export type CommandContext = {
    --- A reference to Cmdr. This may either be the server or client version of Cmdr depending on where the command is running.
    Cmdr: CmdrClient | CmdrServer,
    --- The dispatcher that created this command.
    Dispatcher: Dispatcher,

    --- The name of the command.
    Name: string,
    
    --- The specific alias of this command that was used to trigger this command (may be the same as `Name`)
    Alias: string,
    
    --- The raw text that was used to trigger this command.
    RawText: string,
    
    --- The group this command is a part of. Defined in command definitions, typically a string.
    Group: string,
    
    --- The permissions associated with this command.
    Permissions: string? | {string},
    
    --[=[
        A blank table that can be used to store user-defined information about this command's current execution. 
        
        This could potentially be used with hooks to add information to this table which your command or other hooks could consume.
    ]=]
    State: {any},
    
    --- Any aliases that can be used to also trigger this command in addition to its name.
    Aliases: {string},
    
    --- The description for this command from the command definition.
    Description: string,
    
    --- The player who ran this command.
    Executor: Player,
    
    --- An array of strings which is the raw value for each argument.
    RawArguments: {string},
    
    --- An array of ArgumentContext objects, the parsed equivalent to RawArguments.
    Arguments: {ArgumentContext},
    
    --- The command output, if the command has already been run. Typically only accessible in the `AfterRun` hook.
    Response: string?,

    
    --- Returns the ArgumentContext for the given index.
    GetArgument: (ctx: CommandContext, index: number) -> ArgumentContext,
    
    --- Returns the command data that was sent along with the command. This is the return value of the Data function from the command definition.
    GetData: (ctx: CommandContext) -> any,
    
    --- Returns a table of the given name. Always returns the same table on subsequent calls. Useful for storing things like ban information. Same as `Registry:GetStore`.
    GetStore: (ctx: CommandContext, name: string) -> {},
    
    --- Sends a network event of the given name to the given player. Refer to Network Event Handlers on the Documentation page.
    SendEvent: (ctx: CommandContext, player: Player, event: string, ...any) -> (),
    
    --- Broadcasts a network event to all players. Refer to Network Event Handlers on the Documentation page.
    BroadcastEvent: (ctx: CommandContext, event: string, ...any) -> (),
    
    --[=[
        Prints the given text in the user's console. 
        
        Useful for when a command needs to print more than one message or is long-running. 
        
        You should still return a string from the command implementation when you are finished, `Reply` should only be used to send additional messages before the final message.
    ]=]
    Reply: (ctx: CommandContext, text: string, color: Color3?) -> (),
    
    --[=[
        Returns `true` if the command has an implementation on this machine. 
        
        For example, this function will return false from the client if you call it on a command that only has a server-side implementation. 
            
        Note that commands can potentially run on both the client and the server, so what this property returns on the server is not related to what it returns on the client, and vice versa. 
        
        Likewise, receiving a return value of true on the client does not mean that the command won't run on the server, because Cmdr commands can run a first part on the client and a second part on the server. 
        
        This function only answers one question if you run the command; does it run any code as a result of that on this machine?
    ]=]
    HasImplementation: (ctx: CommandContext) -> boolean,
}

export type ArgumentDefinition = {
    --- The argument type (case sensitive), or an inline `TypeDefinition` object.
    Type: string | TypeDefinition<any>,
    
    --- The argument name, this is displayed to the user as they type. 
    Name: string,
    --- A description of what the argument is, this is also displayed to the user.
    Description: string?,
    --[=[
        If this is set to true, then the user can run the command without filling out the value. 
        
        In which case, the argument will be sent to implementations as nil. 
    ]=]
    Optional: boolean?,
    --[=[
        If present, the argument will be automatically made optional. 
        
        So if the user doesn't supply a value, implementations will receive whatever the value of Default is.
    ]=]
    Default: any?
}

export type CommandDefinition = {
    --- The name of the command
    Name: string,
    
    --[=[
        Aliases which aren't part of auto-complete, but if matched will run this command just the same. 
        
        For example, `m` might be an alias of `announce`.
    ]=]
    Aliases: {string}?,
    
    --- A description of the command, displayed to the user in the help command and auto-complete menu.
    Description: string?,
    
    --[=[
        This property is intended to be used in hooks, so that you can categorise commands 
        and decide if you want a specific user to be able to run them or not. 
        
        But the `help` command will use them as headings.
    ]=]
    Group: string?,
    
    --[=[
        A custom property, used purposefully for storing data that you want to use in order to check the permissions of someone in your Hooks to use the command, seperate from the group command.
    ]=]
    Permissions: string? | {string},
    
    --[=[
        Arguments for the command; 
        
        this is technically optional but if you have no args, 
        set it to `{}` or you may experience some interface weirdness
    ]=]
    Args: {ArgumentDefinition | ((CommandContext) -> ArgumentDefinition)}?,
    
    --[=[
        If your command needs to gather some extra data from the client that's only available on the client, then you can define this function. 
            
        It should accept the command context and tuple of transformed arguments, and return a single value which will be available in the command with `CommandContext:GetData`.
    ]=]
    Data: (CommandContext, ...any) -> any,
    
    --[=[
        If you want your command to run on the client, you can add this function to the command definition itself. 
            
        It works exactly like the function that you would return from the Server module. 
            
        If this function returns a string, the command will run entirely on the client and won't touch the server (which means server-only hooks won't run). 
            
        If this function doesn't return anything, it will fall back to executing the Server module on the server. 
    ]=]
    ClientRun: (CommandContext, ...any) -> string?,
    
    --[=[
        An older version of ClientRun. 
        
        There are very few scenarios where this is preferred to ClientRun (so, in other words, don't use it!). 
        
        These days, Run is only used for some dark magic involving server-sided command objects.
    ]=]
    Run: (CommandContext, ...any) -> string?,
}

export type TypeDefinition<T> = {
    Prefixes: string?,
    DisplayName: string?,
    Default: ((Player) -> string)?,
    Listable: boolean?,
    Transform: (string, Player) -> T?,
    Validate: (T) -> (boolean, string?),
    ValidateOnce: (T) -> (boolean, string?),
    Autocomplete: (T) -> ({string}, {IsPartial: boolean}?)?,
    Parse: (T) -> any,
}

type HasName = Instance | {
    Name: string
}

export type Util = {
    --- Takes an array and flips its values into dictionary keys with value of true.
    MakeDictionary: (array: {any}) -> {[any]: true},
    
    --- Takes a dictionary and returns its keys.
    DictionaryKeys: (dict: {[any]: any}) -> {any},
    
    --[=[
        Returns a function that is a fuzzy finder for the specified set or container.

        Can pass an array of strings, array of instances, array of EnumItems, array of dictionaries with a Name key or an instance (in which case its children will be used).

        Exact matches will be inserted in the front of the resulting array.]]
    ]=]
    MakeFuzzyFinder: (setOrContainer: any) -> (string, boolean?, boolean?) -> string,
    
    --- Makes an Enum type.
    MakeEnumType: <T>(name: string, values: T) -> TypeDefinition<T>,
    
    --- Creates a listable type from a singular type
    MakeListableType: <T>(type: TypeDefinition<T>, override: {}) -> TypeDefinition<T>,
    
    --[=[
        Takes an array of instances (or anything with a Name property) and maps them into an array of their names.

        If no Name property is present, then tostring will be called instead.
    ]=]
    GetNames: (instances: {HasName}) -> {string},
    
    --- Returns the text bounds size based on given text, label (from which properties will be pulled), and optional Vector2 container size.
    GetTextSize: (text: string, label: TextLabel, size: Vector2?) -> Vector2,
    
    --- Splits a string by space but taking into account quoted sequences which will be treated as a single argument.
    SplitString: (text: string, max: number) -> {string},
    
    --- Splits a string using a simple separator (no quote parsing)
    SplitStringSimple: (input: string, sep: string?) -> {string},
    
    --- Replaces arguments in the format $1, $2, $something with whatever the given function returns for it.
    SubstituteArgs: (str: string, replace: string) -> string,
    
    --- Trims whitespace from both sides of a string.
    TrimString: (str: string) -> string,
    
    --- Parses escape sequences into their fully qualified characters
    ParseEscapeSequences: (text: string) -> string,
    
    --- Parses a prefixed union type argument (such as %Team)
    ParsePrefixedUnionType: (typeValue: string, rawValue: string) -> (string?, string?, string?),
    EncodeEscapedOperator: (text: string, op: string) -> string,
    EncodeEscapedOperators: (text: string) -> string,
    
    --- Takes an array of arguments and a max value. Any indicies past the max value will be appended to the last valid argument.
    MashExcessArguments: (arguments: {string}, max: number) -> {string},
    
    --- 
    RunCommandString: (dispatcher: Dispatcher, commandString: string) -> string?,
    
    --- Runs embedded commands and replaces them
    RunEmbeddedCommands: (dispatcher: Dispatcher, str: string) -> string,
    MakeAliasCommand: (name: string, commandString: string) -> CommandDefinition,
}

return {}
