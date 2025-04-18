# Experimental!
I ~ "git: github.com/Marcos-cat/iris"
Dims ← ⊟ 800 600
Vel  ← 100

RandPos ← ⌊ /ℂ ×Dims [⚂⚂]
RandVel ← ⁅ ×Vel ℂ °∠×τ ⚂

┌─╴Boid
  ~ {
    Pos ← ⌊ /ℂ ×Dims [⚂⚂]
    Vel ← ⁅₂ ×Vel ℂ °∠×τ ⚂
    Size ← 10
    BrightColor ← Yellow
    DimColor ← [0.5 0.5 0.5]
    BlinkInterval ← ⁅₁×3⚂
    Timer ← 0
  }
  Move   ← ⍜Pos + ⊙(×I~Dt) ⟜Vel
  Wrap   ← ⍜Pos⍜(⊟°ℂ|◿Dims)
  Blink  ← ⍜(:Timer|⍥×₀):≥⊸⊃(BlinkInterval|Timer)⍜Timer(+I~Dt)
  Update ← Blink Wrap Move
  Render ← I~Draw~Centered~Square⊸⊃(BrightColor|Size|Pos)
  # Render ← I~Draw~Centered~Square [[1 0 0][0 1 0][0 0 1]] ⊸⊃(Size|Pos)
└─╴

Separation ← (
  ⊙˙⊞-     # calc position differences between all boids
  ×        # zero out position differences where distance is greater than perception
  ±/+      # calc normalized separation vectors per boid
  × ⊡₀⤙⊙⊙∘ # scale vectors
  +        # add steering vectors to current velocities
)

⍥(⍚⊂ Boid)2 ⍚¤Boid

I~Open Dims "Boids"
°I~Screen~FPS 60

# Boid!(⊸⊃(Color|Size|Pos))

I~Loop!(
  I~Draw~Background Black
  Boid~Update

  # ⍜(Boid~Color|⍜(⊢|◿₁+0.1)) # ▽ 3 0_0_1
  Boid~Render
)
