extends Object

static func power(body, this):
	body.get_power_node().set_power(Constants.Power.RUNNER)
	return true
