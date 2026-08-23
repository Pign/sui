package sui.mui;

import mui.surface.SurfaceDecl;
import mui.surface.SurfaceRole;
import nui.Snapshot;
import nui.Snapshot.ActionTable;

/**
	The `Glance` surface, sampled for a WidgetKit widget.

	## The same corner, a wider gap

	Android's widget is drawn by the launcher from `RemoteViews` our process
	built; WidgetKit's is drawn by a **separate binary** — an app extension,
	its own process, its own sandbox — which cannot call into this application
	at all. So where `aui` hands Kotlin a JSON string in memory, here the
	string has to *land somewhere both binaries can read*: the App Group
	container both targets are entitled to.

	That is the only difference, and it is worth stating plainly because the
	rest is identical — and is no longer written here. `mui.surface.Follow`
	runs the thunk, describes the tree and projects it, for every snapshot
	surface on every backend. What is left in this file is what is sui's: which
	declaration to follow, and where a tap lands.

	## What crosses, and what cannot

	Not the closures. `project` registers them in an `ActionTable` and writes
	their ids into the tree; the table stays in the process that sampled, and
	the extension will never share ours.

	## So the extension runs its own instance

	A tap in a WidgetKit widget is an `AppIntent`, and it runs in the
	extension's process — where our closures are not. Android's tap lands in
	the application's own process and simply finds them; here there is nothing
	to find.

	The answer is not to send the action somewhere. It is to have an
	application **there**: the extension boots the same Haxe runtime, builds
	the same application, samples the same declaration — which rebuilds an
	`ActionTable` in *its* process — and invokes. Ids are keyed by PLACE, so
	the button in the same slot has the same id in both processes, and the id
	the launcher sends resolves against a table it never saw built.

	Two instances of one application then exist, with two sets of cells, and
	that is exactly why the durable store came first: a cell declared
	`@:state(durable)` is the same value in both, and everything else is the
	instance's own. A closure that reads an ordinary cell in the extension
	reads a draft that never existed — the danger the plan names, and the one
	worth a compile-time check when this widens past a counter.
**/
@:keep
class GlanceBridge {
	static var _sampled:Null<sui.mui.App> = null;
	static var _follower:Null<mui.surface.Follow.Follower> = null;

	/**
		Remember the application without sampling it.

		Called from `sui.mui.App`'s constructor, where sampling would be fatal
		— the subclass has not initialised its `@:state` fields yet, so the
		declaration's thunk would read a null cell and take the boot down with
		it. Holding the reference costs nothing and is what lets the surface be
		followed later, when the application is whole.
	**/
	public static function attach(app:sui.mui.App):Void {
		_sampled = app;
	}

	/** The Glance declaration this application makes, or `null`. **/
	public static function declaration():Null<SurfaceDecl> {
		var mine = _sampled;
		return mine == null ? null : pickGlance(mine.surfaces());
	}

	/** Told who is following, so a tap can reach the table that follower owns.
		The table lives with the effect that fills it -- keeping a second one
		here is how ids and closures drift apart. **/
	public static function followedBy(f:Null<mui.surface.Follow.Follower>):Void {
		_follower = f;
	}

	/**
		Run the closure the widget's tap names.

		The caller must be following first, in this process, or the table is
		empty and the id names nothing. `GlancePublish.invokeAndPublish` is what
		does that in order.

		An id that resolves to nothing is not silence: `ActionTable.invoke` says
		so. In a cold extension the usual cause is a tree whose shape changed
		between the picture the launcher kept and this sample — a list one item
		shorter — and the honest answer is to say which id went missing rather
		than to run a neighbour's closure.
	**/
	public static function invoke(id:Int, ?arg:String):Void {
		var f = _follower;
		if (f != null) f.invoke(id, arg);
	}

	/**
		Same rule `qui` applies to the cover and `aui` to the widget: the
		declaration whose id is the role's default if there is one, else the
		first declared. Stated rather than left to iteration order, which is
		not identity.
	**/
	static function pickGlance(decls:Array<SurfaceDecl>):Null<SurfaceDecl> {
		var first:Null<SurfaceDecl> = null;
		for (d in decls) switch (d) {
			case Tree(SurfaceRole.Glance, id, _):
				if (id == "glance") return d;
				if (first == null) first = d;
			case _:
		}
		return first;
	}
}
