


systems = {}
current = 1
vol = 1.0
maxvol = 2.0
minvol = 0.1

function love.load()
	part1 = love.graphics.newImage("part1.png");
	cloud = love.graphics.newImage("cloud.png");
	square = love.graphics.newImage("square.png")
	font = love.graphics.newFont(love._vera_ttf, 10)
	music = love.audio.newSource("inception.ogg")
	inception = love.audio.newSource("horns.ogg","static")
	music:setLooping(1)
	love.graphics.setFont(font)
	love.graphics.setColor(200, 200, 200);
	
	local p = love.graphics.newParticleSystem(part1, 1000)
	p:setEmissionRate(500)
	p:setSpeed(300, 400)
	p:setGravity(0)
	p:setSize(2, 1)
	p:setColor(255, 255, 255, 255, 58, 128, 255, 0)
	p:setPosition(400, 300)
	p:setLifetime(1)
	p:setParticleLife(1)
	p:setDirection(0)
	p:setSpread(360)
	p:setRadialAcceleration(-2000)
	p:setTangentialAcceleration(1000)
	p:stop()
	table.insert(systems, p)

	p = love.graphics.newParticleSystem(cloud, 1000)
	p:setEmissionRate(500)
	p:setSpeed(200, 250)
	p:setGravity(100, 200)
	p:setSize(1, 1)
	p:setColor(16, 81, 229, 255, 176, 16, 229, 0)
	p:setPosition(400, 300)
	p:setLifetime(1)
	p:setParticleLife(1)
	p:setDirection(180)
	p:setSpread(20)
	--p:setRadialAcceleration(-200, -300)
	p:stop()
	table.insert(systems, p)		

	p = love.graphics.newParticleSystem(square, 1000)
	p:setEmissionRate(60)
	p:setSpeed(200, 250)
	p:setGravity(100, 200)
	p:setSize(1, 2)
	p:setColor(240, 3, 176, 255, 204, 240, 3, 0)
	p:setPosition(400, 300)
	p:setLifetime(1)
	p:setParticleLife(2)
	p:setDirection(90)
	p:setSpread(0)
	p:setSpin(300, 800)
	p:stop()
	table.insert(systems, p)		

	p = love.graphics.newParticleSystem(part1, 1000)
	p:setEmissionRate(1000)
	p:setSpeed(300, 400)
	p:setSize(2, 1)
	p:setColor(220, 105, 20, 255, 194, 30, 18, 0)
	p:setPosition(400, 300)
	p:setLifetime(0.1)
	p:setParticleLife(0.2)
	p:setDirection(0)
	p:setSpread(360)
	p:setTangentialAcceleration(1000)
	p:setRadialAcceleration(-2000)
	p:stop()
	table.insert(systems, p)	

	p = love.graphics.newParticleSystem(part1, 1000)
	p:setEmissionRate(200)
	p:setSpeed(300, 400)
	p:setSize(1, 2)
	p:setColor(255, 255, 255, 255, 255, 128, 128, 0)
	p:setPosition(400, 300)
	p:setLifetime(1)
	p:setParticleLife(2)
	p:setDirection(0)
	p:setSpread(360)
	p:setTangentialAcceleration(2000)
	p:setRadialAcceleration(-8000)
	p:stop()
	table.insert(systems, p)			
		
end

direction = 0

function love.update(dt)

	if love.mouse.isDown("l") then
		systems[current]:setPosition(love.mouse.getX(), love.mouse.getY())
		systems[current]:start()
	end
	
	if love.keyboard.isDown("d") then
		systems[current]:setDirection(direction)
		direction = math.mod(direction + 90 * dt, 360)
	end
		
	systems[current]:update(dt)
end

function love.draw()
		
		love.graphics.setColorMode("modulate")
		love.graphics.setBlendMode("additive")
		
		love.graphics.draw(systems[current], 0, 0)
		love.graphics.print("System: [" .. current .. "/"..table.getn(systems).."] - " .. systems[current]:count() .. " particles.", 30, 570);
		love.graphics.print("Click: spawn bradicles. Mousewheel: change system.", 30, 530);
		love.graphics.print("Press escape to exit.", 30, 550);
		love.graphics.print("If you lockup use R to reset the game.", 30, 510);
		love.graphics.print("Space: Start music (Pause and resume)", 30, 10);
		love.graphics.print("Press LShift to go deeper.", 30, 40);
		love.graphics.print("Volume Level: " .. vol .. " times normal volume.", 300, 40);
		love.graphics.print("Use Up and Down Arrows to change the BGM volume", 300, 10);
end

function love.mousepressed(x, y, button)
	if button == "wu" then
		current = current + 1;
		if current > table.getn(systems) then current = table.getn(systems) end
	end

	if button == "wd" then
		current = current - 1;
		if current < 1 then current = 1 end
	end
end

function love.keypressed(key)
	if key == "escape" then
		love.event.push("q")
	end
	
	if key == "r" then
		music:stop()
		inception:stop()
		love.filesystem.load("main.lua")()
		love.load()
	end
	
	if key == " " then
		if music:isStopped() then
			love.audio.play(music)
		else
			if music:isPaused() then
				music:resume()
			else music:pause()
			end
		end
	end
	
	if key == "lshift" then
		inception:play()
	end
	
	if key == "up" then
		vol = vol + 0.1;
		if vol > maxvol then vol = maxvol end
		music:setVolume(vol)
	end
	
	if key == "down" then
		vol = vol - 0.1;
		if vol < minvol then vol = minvol end
		music:setVolume(vol)
	end
		
end