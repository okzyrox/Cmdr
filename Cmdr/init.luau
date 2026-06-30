local RunService = game:GetService("RunService")
local Util = require(script.Shared:WaitForChild("Util"))
local Types = require(script.Shared:WaitForChild("CmdrTypes"))

if RunService:IsServer() == false then
	error(
		"[Cmdr] Client scripts cannot require the server library. Please require the client library from the client to use Cmdr in your own code."
	)
end

--[=[
	@class Cmdr
	@server

	The Cmdr server singleton and entry point.
]=]

--[=[
	@within Cmdr
	@prop Registry Registry
	@readonly
	Refers to the current command Registry.
]=]

--[=[
	@within Cmdr
	@prop Dispatcher Dispatcher
	@readonly
	Refers to the current command Dispatcher.
]=]

--[=[
	@within Cmdr
	@prop Util Util
	@readonly
	Refers to a table containing many useful utility functions.
]=]

local Cmdr
do
	Cmdr = setmetatable({
		ReplicatedRoot = nil,
		RemoteFunction = nil,
		RemoteEvent = nil,
		Util = Util,
		DefaultCommandsFolder = script.BuiltInCommands,
	}, {
		__index = function(self, k)
			local r = self.Registry[k]
			if r and type(r) == "function" then
				return function(_, ...)
					return r(self.Registry, ...)
				end
			end
		end,
	})

	Cmdr.Registry = require(script.Shared.Registry)(Cmdr)
	Cmdr.Dispatcher = require(script.Shared.Dispatcher)(Cmdr)

	require(script.Initialize)(Cmdr)
end

-- Handle command invocations from the clients.
Cmdr.RemoteFunction.OnServerInvoke = function(player, text, options)
	if #text > 10000 then
		return "Input too long"
	end

	return Cmdr.Dispatcher:EvaluateAndRun(text, player, options)
end

export type ArgumentContext = Types.ArgumentContext
export type CommandContext = Types.CommandContext
export type CommandDefinition = Types.CommandDefinition
export type ArgumentDefinition = Types.ArgumentDefinition
export type TypeDefinition<T> = Types.TypeDefinition<T>
export type CmdrServer = Types.CmdrServer
export type CmdrClient = Types.CmdrClient
export type Registry = Types.Registry
export type Dispatcher = Types.Dispatcher
export type Util = Types.Util

return Cmdr :: CmdrServer
