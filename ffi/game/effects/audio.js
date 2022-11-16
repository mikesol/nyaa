"use strict";

export class AudioEffect {
    constructor(audioContext, audioSource) {
        this.audioContext = audioContext;
        this.vanillaGain = new GainNode(audioContext, { gain: 1.0 });
        this.biquadGain = new GainNode(audioContext, { gain: 0.0 });
        this.biquadFilter = new BiquadFilterNode(audioContext, { frequency: 600.0 });
        this.biquadFilter.type = "lowpass";

        audioSource.connect(this.vanillaGain);
        audioSource.connect(this.biquadFilter);
        this.vanillaGain.connect(audioContext.destination);
        this.biquadFilter.connect(this.biquadGain);
        this.biquadGain.connect(audioContext.destination);

        this.startTime = null;
        this.endTime = null;
        this.offset = null;
        this.isActive = false;
        this.isEnding = false;
    }

    setType(type) {
        if (this.isActive) {
            return;
        }
        this.biquadFilter.type = type;
    }

    activate(startTime, duration, offset) {
        if (this.isActive) {
            return;
        }
        this.startTime = startTime;
        this.endTime = startTime + duration;
        this.offset = offset;
        this.isActive = true;
        this.isEnding = false;
        this.vanillaGain.gain.setTargetAtTime(0.0, this.startTime + this.offset, 0.5);
        this.biquadGain.gain.setTargetAtTime(1.0, this.startTime + this.offset, 0.5);
    }

    animate(elapsedTime) {
        if (!this.isActive) {
            return;
        }
        if (elapsedTime >= this.endTime - this.offset && !this.isEnding) {
            this.vanillaGain.gain.setTargetAtTime(1.0, this.endTime, 0.5);
            this.biquadGain.gain.setTargetAtTime(0.0, this.endTime, 0.5);
            this.isEnding = true;
        }
        if (elapsedTime >= this.endTime) {
            this.isActive = false;
            this.isEnding = false;
        }
    }
}
