
# Copyright (C) 2026 Rhys Weatherley
#
# Permission is hereby granted, free of charge, to any person obtaining a
# copy of this software and associated documentation files (the "Software"),
# to deal in the Software without restriction, including without limitation
# the rights to use, copy, modify, merge, publish, distribute, sublicense,
# and/or sell copies of the Software, and to permit persons to whom the
# Software is furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included
# in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
# OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
# FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
# DEALINGS IN THE SOFTWARE.

import lgp21.insn as insn

'''
Pretty-print a device name.
'''
def device_name(track, sector):
    if track == 0 and sector == 0:
        return 'tape reader'
    elif track == 2 and sector == 0:
        return 'typewriter'
    elif track == 6 and sector == 0:
        return 'tape punch'
    else:
        return 'device %02d%02d' % (track, sector)

'''
Explain an instruction word in greater detail.
'''
def explain(word):
    order = word & insn.ORDER_MASK
    address = (word & insn.ADDRESS_MASK) >> insn.ADDRESS_SHIFT
    track = (word & insn.TRACK_MASK) >> insn.TRACK_SHIFT
    sector = (word & insn.SECTOR_MASK) >> insn.SECTOR_SHIFT
    match order:
        case insn.STOP:
            if track == 0 or track == 1:
                return 'Halt'
            elif track == 2 or track == 3:
                return 'NOP'
            else:
                return 'Skip if switches 0x%02x are set' % track

        case insn.OVERFLOW:
            if track == 0 or track == 1:
                return 'Skip if overflow is set and halt'
            elif track == 2 or track == 3:
                return 'Skip if overflow is set'
            else:
                return 'Skip if overflow or switches 0x%02x are set' % track

        case insn.BRING:
            return 'Load A from [%02d%02d]' % (track, sector)

        case insn.STORE:
            return 'Store A to address field of [%02d%02d]' % (track, sector)

        case insn.RETURN:
            return 'Store return address to [%02d%02d]' % (track, sector)

        case insn.INPUT6:
            if address == 0xF80 or address == 0xFC0:
                return 'Shift A left by 6 bits'
            else:
                return '6-bit input from %s' % device_name(track, sector)

        case insn.INPUT4:
            if address == 0xF80 or address == 0xFC0:
                return 'Shift A left by 4 bits'
            else:
                return '4-bit input from %s' % device_name(track, sector)

        case insn.DIV:
            return 'Divide A by [%02d%02d]' % (track, sector)

        case insn.MUL_L:
            return 'Multiply A by [%02d%02d], low bits' % (track, sector)

        case insn.MUL_H:
            return 'Multiply A by [%02d%02d], high bits' % (track, sector)

        case insn.PRINT6:
            return 'Print 6-bit character to %s' % device_name(track, sector)

        case insn.PRINT4:
            return 'Print 4-bit character to %s' % device_name(track, sector)

        case insn.EXTRACT:
            return 'Bitwise AND [%02d%02d] with A' % (track, sector)

        case insn.UNCOND:
            return 'Jump to %02d%02d' % (track, sector)

        case insn.COND:
            return 'Jump to %02d%02d if A is negative' % (track, sector)

        case insn.CTRL:
            return 'Jump to %02d%02d if A is negative or TC is set' % (track, sector)

        case insn.HOLD:
            return 'Store A to [%02d%02d]' % (track, sector)

        case insn.CLEAR:
            return 'Store A to [%02d%02d] and clear A' % (track, sector)

        case insn.ADD:
            return 'Add [%02d%02d] to A' % (track, sector)

        case insn.SUB:
            return 'Subtract [%02d%02d] from A' % (track, sector)
    return ''

'''
Disassemble an instruction word.
'''
def disassemble(word):
    order = word & insn.ORDER_MASK
    track = (word & insn.TRACK_MASK) >> insn.TRACK_SHIFT
    sector = (word & insn.SECTOR_MASK) >> insn.SECTOR_SHIFT
    if order in insn.order_names and (word & 0x7FF00003) == 0:
        return "%08x  %2s %02d%02d   %s" % (word, insn.order_names[order].upper(), track, sector, explain(word))
    else:
        return "%08x" % word
