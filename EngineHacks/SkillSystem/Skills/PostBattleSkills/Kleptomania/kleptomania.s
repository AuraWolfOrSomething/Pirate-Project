.macro blh to, reg=r3
  ldr \reg, =\to
  mov lr, \reg
  .short 0xf800
.endm
.equ KleptomaniaID, SkillTester+4
.equ KleptomaniaEvent, KleptomaniaID+4
.thumb
push	{lr}

@check if dead
ldrb	r0, [r4,#0x13]
cmp	r0, #0x00
beq	End

@check if attacked this turn
ldrb 	r0, [r6,#0x11]	@action taken this turn
cmp	r0, #0x6 @steal
bne	End
ldrb 	r0, [r6,#0x0C]	@allegiance byte of the current character taking action
ldrb	r1, [r4,#0x0B]	@allegiance byte of the character we are checking
cmp	r0, r1		@check if same character
bne	End

@check for skill
mov	r0, r4
ldr	r1, KleptomaniaID
ldr	r3, SkillTester
mov	lr, r3
.short	0xf800
cmp	r0, #0x00
beq	End

Event:
ldrb  r2, [r4,#0x12]
strb  r2, [r4,#0x13]
mov r2, #0x28
mov r3, #0x30
strb  r2, [r4,r3]

mov r3, #0x00
ldrb  r0, [r4,#0x11]    @load y coordinate of character
lsl r0, #0x10
add r3, r0
ldrb  r0, [r4,#0x10]    @load x coordinate of character
add r3, r0
ldr r1,=#0x30004E4    @and store them for the event engine
str r3, [r1]

ldr r0,=#0x800D07C    @event engine thingy
mov lr, r0
ldr r0, KleptomaniaEvent  @this event does the warp animation
mov r1, #0x01   @0x01 = wait for events
.short  0xF800

End:
pop	{r0}
bx	r0
.ltorg
.align
SkillTester:
@POIN SkillTester
@WORD KleptomaniaID
@POIN KleptomaniaEvent
