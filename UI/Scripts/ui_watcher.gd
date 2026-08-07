class_name UIWatcher


## Permite conectar una señal y garantiza que se desconectará
## automáticamente cuando el nodo de UI salga del árbol o sea liberado.
static func watch(node: Node, signal_to_connect: Signal, method: Callable) -> void:
	var emitter := signal_to_connect.get_object()
	if emitter == null:
		assert(
			false,
			"Error de señal: el emisor de la señal " + signal_to_connect.get_name() + " es nulo",
		)
		return

	if not signal_to_connect.is_connected(method):
		signal_to_connect.connect(method)

	var cleanup: Callable
	cleanup = func():
		if is_instance_valid(emitter) and signal_to_connect.is_connected(method):
			signal_to_connect.disconnect(method)
		if node.tree_exiting.is_connected(cleanup):
			node.tree_exiting.disconnect(cleanup)

	if not node.tree_exiting.is_connected(cleanup):
		node.tree_exiting.connect(cleanup, CONNECT_ONE_SHOT)
