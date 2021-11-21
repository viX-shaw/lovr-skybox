function lovr.conf(t)
	t.modules.headset = true
	t.headset.drivers = { 'openxr', 'oculus', 'vrapi', 'pico', 'openvr', 'webxr', 'desktop' }
	-- t.headset.drivers = {'openvr'}
end