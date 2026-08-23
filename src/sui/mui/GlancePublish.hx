package sui.mui;

/**
	Hands a sampled Glance surface to the native side, which stores it where
	the widget extension can read it.

	## Why a C symbol and not a callback

	The other direction — Swift asking Haxe for the view tree — is what
	`ViewNodeBridgeC` exists for, and Swift registering callbacks into Haxe is
	how state changes travel back. This one goes the other way at a moment
	Swift is not driving, so it is a plain `extern "C"` call into a function
	the generated Swift exports with `@_cdecl`, resolved at the final link
	like any other symbol in the app binary. It is the arrangement `wui` uses
	for its whole node runtime.

	The shim is emitted for **every** sui application, and does nothing when
	there is no widget. That is deliberate: this class is compiled into every
	app that touches `mui.surface.Resample`, and a symbol that existed only
	for widget-declaring apps would turn a missing feature into a link error.
**/
@:keep
@:cppFileCode('#include <dlfcn.h>\ntypedef void (*sui_glance_publish_fn)(const char*);')
class GlancePublish {
	/**
		Take a new sample of the running application and publish it.

		Called from the generated C entry `sui_glance_resample`, which the
		scene-phase observer in App.swift reaches when the application leaves
		the foreground. Nothing here knows which application: the bridge kept
		the one it last sampled, and on this backend there is only ever one.
	**/
	@:keep public static function resampleAndPublish():Void {
		var f = _follower;
		if (f == null) return;
		var json = f.sampleNow();
		if (json != null) publish(json);
	}

	/** What is following the Glance declaration, or `null` while nothing is. **/
	static var _follower:Null<mui.surface.Follow.Follower> = null;

	/**
		Begin following the Glance declaration, so a write republishes it.

		The mechanism is `mui.surface.Follow` — shared with `aui`'s widget and
		with the Companion projection, because a snapshot surface has no host
		reactivity anywhere and noticing is always ours to do. What stays here
		is the one thing that is sui's: writing the picture into the App Group
		container the extension reads.

		**Idempotent, and called from both processes.** The application starts
		it after `setApp`, when the instance is whole — the constructor is too
		early, for the reason `GlanceBridge.attach` documents. The extension
		starts it before invoking a tap, which is also what builds the action
		table there.

		`publishFirst` is false in the extension: its first run would publish
		this process's own pre-tap state over the application's picture. That
		question now lives in `Follow`, asked once for every backend.
	**/
	@:keep public static function follow(publishFirst:Bool = true):Void {
		if (_follower != null) return;
		var decl = sui.mui.GlanceBridge.declaration();
		if (decl == null) return;
		_follower = mui.surface.Follow.surface(decl, publish, publishFirst);
		sui.mui.GlanceBridge.followedBy(_follower);
	}

	/** Stop following. For a host tearing the application down. **/
	@:keep public static function unfollow():Void {
		var f = _follower;
		_follower = null;
		sui.mui.GlanceBridge.followedBy(null);
		if (f != null) f.dispose();
	}

	/**
		A tap in the widget, run in the widget's own process.

		Called from the generated C entry `sui_glance_invoke`, which the
		extension's `AppIntent` reaches after `sui_glance_boot_headless`. Three
		steps now, and the order still matters:

		1. **Name ourselves.** Writes from here are the extension's, not the
		   application's. The sequence arbitrates, never the name — but a store
		   a human reads should say who wrote what.
		2. **Rehydrate.** The application may have changed a durable cell since
		   this process last looked, and an extension process is kept alive
		   between taps; what it holds is only right after asking the store.
		3. **Follow, then invoke.** Following samples once, which is what builds
		   the `ActionTable` in this process and makes the launcher's id resolve
		   — ids are keyed by place, so the same button gets the same id here as
		   it got in the application.

		**This method used to sample twice and publish by hand**, and said so at
		length: the first sample to make the id mean something, the second to
		show the result. The second is gone. The closure writes a cell, the
		effect started in step 3 wakes on that write, samples and publishes —
		the same path a change from anywhere else takes. Republishing here as
		well would publish the same picture twice.
	**/
	@:keep public static function invokeAndPublish(id:Int):Void {
		rui.state.Durable.writer = "glance";
		rui.state.Durable.rehydrate();

		// Starting to follow IS the sample that builds the action table in this
		// process, which is what makes the launcher's id resolve. It used to be
		// an explicit `sampleAgain()` here; the effect's first run does it.
		// `false`: do not publish on the way in. The first run samples, which is
		// what builds the action table here — publishing it would put this
		// process's own state on the widget before the tap is even applied.
		follow(false);
		var f = _follower;
		if (f == null) return; // no Glance declaration: nothing to act on

		// The republish is not written here: the closure writes a cell, the
		// effect wakes on it, samples and publishes. One path for a tap and for
		// anything else that moves the same cell.
		f.invoke(id);
	}

	/**
		The application came back to the foreground.

		Called from the generated C entry `sui_app_resumed`. One integer read
		when nothing changed, which is what lets this sit on a lifecycle event
		instead of a timer — and a timer is what it would have to be otherwise,
		since nothing tells one process that another one wrote.

		The moment is named on purpose. Cells rewritten from a background
		thread under a running effect is a different and much worse problem
		than a number that is a few hundred milliseconds stale.
	**/
	@:keep public static function resumed():Void {
		rui.state.Durable.rehydrate();
	}

	/**
		Hand the snapshot to the native side, if there is one to hand it to.

		The symbol is looked up at RUNTIME rather than linked, and that is
		not fussiness. This class is compiled into every application that
		touches `mui.surface.Resample`, including the plain Haxe executable a
		macOS build links **before Xcode ever sees it** — a link with no Swift
		in it at all, which an ordinary reference fails. A weak declaration
		does not save it either: on Darwin `weak` marks a definition, and an
		undefined weak reference still has to resolve. `dlsym(RTLD_DEFAULT)`
		asks the process, at the moment it matters, whether anyone published
		that function — which is exactly the question.
	**/
	public static function publish(json:String):Void {
		#if cpp
		untyped __cpp__("{ static sui_glance_publish_fn fn = (sui_glance_publish_fn)dlsym(RTLD_DEFAULT, \"sui_glance_publish\"); if (fn) fn({0}.utf8_str()); }", json);
		#end
	}
}
