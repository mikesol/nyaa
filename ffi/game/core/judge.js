"use strict";

export const TABLE_SAMPLES_PER_SECOND = 60;
export const NUMBER_OF_COLUMNS = 4;

export class Judge {
    constructor(notes, chartLengthInSeconds) {
        this.notes = notes;
        for (const note of notes) {
            note.hasHit = false;
        }
        this.table = new Float32Array(chartLengthInSeconds * TABLE_SAMPLES_PER_SECOND * NUMBER_OF_COLUMNS);
        for (let i = 0, j = 0; i < chartLengthInSeconds * TABLE_SAMPLES_PER_SECOND; i++) {
            const quantizedTime = i / TABLE_SAMPLES_PER_SECOND;
            while (j < notes.length && notes[j].timing + 0.1 < quantizedTime) {
                j++;
            }
            let k = j;
            while (k < notes.length && notes[k].timing - 0.1 < quantizedTime) {
                const columnIndex = notes[k].column;
                const tableIndex = i * NUMBER_OF_COLUMNS + columnIndex;
                this.table[tableIndex] = this.table[tableIndex] === 0 || notes[this.table[tableIndex]].timing < quantizedTime ? k + 1 : this.table[tableIndex];
                k++;
            }
        }
    }

    judge(elapsedTime, column, callback) {
        const tableIndex = Math.floor(elapsedTime * TABLE_SAMPLES_PER_SECOND) * NUMBER_OF_COLUMNS + column;
        const noteIndex = this.table[tableIndex];
        if (noteIndex === 0 || noteIndex === undefined) {
            return null;
        }
        const latestNote = this.notes[noteIndex - 1];
        const checkThresholdBefore = latestNote.timing - 0.1;
        const checkThresholdAfter = latestNote.timing + 0.1;
        if (latestNote.hasHit) {
            return;
        }
        if ((elapsedTime >= checkThresholdBefore && elapsedTime <= latestNote.timing) || (elapsedTime >= latestNote.timing && elapsedTime <= checkThresholdAfter)) {
            const timingDifference = elapsedTime - latestNote.timing;
            const beforePerfect = Math.abs(timingDifference);
            if (beforePerfect < 0.05) {
                callback("perfect");
                latestNote.hasHit = true;
            } else if (beforePerfect > 0.05 && beforePerfect < 0.1) {
                callback("near");
                latestNote.hasHit = true;
            }
        }
    }

    checkMiss(elapsedTime, callback) {
        const tableIndices = [
            Math.floor(elapsedTime * TABLE_SAMPLES_PER_SECOND) * NUMBER_OF_COLUMNS + 0,
            Math.floor(elapsedTime * TABLE_SAMPLES_PER_SECOND) * NUMBER_OF_COLUMNS + 1,
            Math.floor(elapsedTime * TABLE_SAMPLES_PER_SECOND) * NUMBER_OF_COLUMNS + 2,
            Math.floor(elapsedTime * TABLE_SAMPLES_PER_SECOND) * NUMBER_OF_COLUMNS + 3,
        ];
        const noteIndices = [
            this.table[tableIndices[0]],
            this.table[tableIndices[1]],
            this.table[tableIndices[2]],
            this.table[tableIndices[3]],
        ];
        for (const noteIndex of noteIndices) {
            if (noteIndex === 0 || noteIndex === undefined) {
                continue;
            }
            const latestNote = this.notes[noteIndex - 1];
            if (latestNote.hasHit || latestNote.hasHit === "miss") {
                continue;
            }
            if (elapsedTime >= latestNote.timing + 0.09) {
                callback();
                latestNote.hasHit = "miss";
            }
        }
    }
}
