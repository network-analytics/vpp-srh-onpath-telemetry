-- Wireshark post-dissector for the IOAM Direct Export (DEX) option carried in the IPv6
-- Hop-by-Hop header (RFC 9326, RFC 9486), including the Timestamp Seconds/Fraction
-- extension of draft-netana-ippm-ioam-on-path-delay.
--
-- The tree "IOAM Direct Export (DEX) Option" is added at the end of the packet details.
-- Display filters: ioam_dex.namespace_id, ioam_dex.ts_sec, ioam_dex.capture_delta_us, ...

-- Placeholders until IANA assigns the bits (TBD1, TBD2, TBD3 of the draft).
local EXT_FLOW_ID = 0x80
local EXT_SEQ_NUM = 0x40
local EXT_TS_SEC  = 0x20
local EXT_TS_FRAC = 0x10
local TT_ON_PATH_DELAY = 0x000800

local IOAM_TYPE_DEX = 4
-- RFC 9486 gives 0x11 for DEX; 0x31 is accepted too since both carry IOAM options
local DEX_OPT_TYPES = { [0x11] = true, [0x31] = true }

local dex = Proto("ioam_dex", "IOAM Direct Export (DEX) Option")

dex.prefs.frac_us = Pref.bool("Timestamp fraction is in microseconds (POSIX)", false,
  "Off: PTP truncated format, fraction in nanoseconds. On: POSIX format, fraction in microseconds. " ..
  "Must match 'ts-format-sub' of the IOAM profile (ns or us).")

local ioam_type_names = {
  [0] = "Pre-allocated Trace Option-Type",
  [1] = "Incremental Trace Option-Type",
  [2] = "Proof of Transit (POT) Option-Type",
  [3] = "Edge-to-Edge Option-Type",
  [4] = "Direct Export (DEX) Option-Type",
}

local action_names = {
  [0] = "Skip and continue",
  [1] = "Discard",
  [2] = "Discard and send ICMP",
  [3] = "Discard and send ICMP if not multicast",
}

-- Bit numbers count from the most significant bit of the 24-bit IOAM-Trace-Type (RFC 9197)
local trace_bits = {
  { 0x800000, "Bit 0: Hop_Lim and node_id (short)" },
  { 0x400000, "Bit 1: ingress and egress interface ids (short)" },
  { 0x200000, "Bit 2: timestamp seconds" },
  { 0x100000, "Bit 3: timestamp fraction" },
  { 0x080000, "Bit 4: transit delay" },
  { 0x040000, "Bit 5: namespace-specific data" },
  { 0x020000, "Bit 6: queue depth" },
  { 0x010000, "Bit 7: checksum complement" },
  { 0x008000, "Bit 8: Hop_Lim and node_id (wide)" },
  { 0x004000, "Bit 9: ingress and egress interface ids (wide)" },
  { 0x002000, "Bit 10: namespace-specific data (wide)" },
  { 0x001000, "Bit 11: buffer occupancy" },
  { TT_ON_PATH_DELAY, "Bit 12: on-path delay (placeholder, TBD3)" },
  { 0x000002, "Bit 22: opaque state snapshot" },
  { 0x000001, "Bit 23: reserved" },
}

local f = dex.fields
f.opt_type  = ProtoField.uint8("ioam_dex.opt_type", "Option Type", base.HEX)
f.opt_act   = ProtoField.uint8("ioam_dex.opt_type.action", "Action", base.DEC, action_names, 0xC0)
f.opt_chg   = ProtoField.bool("ioam_dex.opt_type.chg", "May change en route", 8, nil, 0x20)
f.opt_num   = ProtoField.uint8("ioam_dex.opt_type.number", "Option number", base.DEC, nil, 0x1F)
f.opt_len   = ProtoField.uint8("ioam_dex.opt_len", "Opt Data Len", base.DEC)
f.reserved  = ProtoField.uint8("ioam_dex.reserved", "Reserved", base.HEX)
f.ioam_type = ProtoField.uint8("ioam_dex.ioam_type", "IOAM Option-Type", base.DEC, ioam_type_names)
f.namespace = ProtoField.uint16("ioam_dex.namespace_id", "Namespace-ID", base.DEC)
f.flags     = ProtoField.uint8("ioam_dex.flags", "Flags", base.HEX)
f.ext_flags = ProtoField.uint8("ioam_dex.ext_flags", "Extension-Flags", base.HEX)
f.ext_flow  = ProtoField.bool("ioam_dex.ext_flags.flow_id", "Flow ID present", 8, nil, EXT_FLOW_ID)
f.ext_seq   = ProtoField.bool("ioam_dex.ext_flags.seq_num", "Sequence Number present", 8, nil, EXT_SEQ_NUM)
f.ext_sec   = ProtoField.bool("ioam_dex.ext_flags.ts_sec", "Timestamp Seconds present (placeholder, TBD1)", 8, nil, EXT_TS_SEC)
f.ext_frac  = ProtoField.bool("ioam_dex.ext_flags.ts_frac", "Timestamp Fraction present (placeholder, TBD2)", 8, nil, EXT_TS_FRAC)
f.trace_type = ProtoField.uint24("ioam_dex.trace_type", "IOAM-Trace-Type", base.HEX)
f.trace_rsvd = ProtoField.uint8("ioam_dex.trace_type.reserved", "Reserved", base.HEX)
f.flow_id   = ProtoField.uint32("ioam_dex.flow_id", "Flow ID", base.DEC)
f.seq_num   = ProtoField.uint32("ioam_dex.seq_num", "Sequence Number", base.DEC)
f.ts_sec    = ProtoField.uint32("ioam_dex.ts_sec", "Timestamp Seconds", base.DEC)
f.ts_frac   = ProtoField.uint32("ioam_dex.ts_frac", "Timestamp Fraction", base.DEC)
f.encap_time = ProtoField.absolute_time("ioam_dex.encap_time", "Encapsulation time", base.UTC)
f.capture_delta = ProtoField.relative_time("ioam_dex.capture_delta", "Capture time minus encapsulation time")
f.capture_delta_us = ProtoField.double("ioam_dex.capture_delta_us", "Capture time minus encapsulation time (us)")

local tt_fields = {}
for i, bit in ipairs(trace_bits) do
  tt_fields[i] = ProtoField.bool("ioam_dex.trace_type.bit" .. i, bit[2], 24, nil, bit[1])
  f["tt_bit" .. i] = tt_fields[i]
end

local hbh_ok, hbh_field = pcall(Field.new, "ipv6.hopopts")
if not hbh_ok then
  hbh_field = nil
end

local frame_time_field = Field.new("frame.time_epoch")

-- True when the single-bit mask is set in v (portable across Lua versions)
local function has_bit(v, mask)
  return math.floor(v / mask) % 2 == 1
end

local function dissect_dex(o, pinfo, tree)
  local namespace = o(4, 2):uint()
  local flags_ext = o(7, 1):uint()
  local trace_type = o(8, 3):uint()

  local sub = tree:add(dex, o)
  sub:append_text(string.format(": namespace %d, trace type 0x%06x", namespace, trace_type))

  local ot = sub:add(f.opt_type, o(0, 1))
  ot:add(f.opt_act, o(0, 1))
  ot:add(f.opt_chg, o(0, 1))
  ot:add(f.opt_num, o(0, 1))
  sub:add(f.opt_len, o(1, 1))
  sub:add(f.reserved, o(2, 1))
  sub:add(f.ioam_type, o(3, 1))
  sub:add(f.namespace, o(4, 2))
  sub:add(f.flags, o(6, 1))

  local ef = sub:add(f.ext_flags, o(7, 1))
  ef:add(f.ext_flow, o(7, 1))
  ef:add(f.ext_seq, o(7, 1))
  ef:add(f.ext_sec, o(7, 1))
  ef:add(f.ext_frac, o(7, 1))

  local tt = sub:add(f.trace_type, o(8, 3))
  for i = 1, #trace_bits do
    tt:add(tt_fields[i], o(8, 3))
  end
  if has_bit(trace_type, TT_ON_PATH_DELAY) then
    tt:append_text(" (on-path delay)")
  end
  sub:add(f.trace_rsvd, o(11, 1))

  -- Optional 4-octet fields follow in Extension-Flags bit order
  local off = 12
  local len = o:len()
  local sec_off, frac_off
  local function optional(flag, field, name)
    if not has_bit(flags_ext, flag) then
      return nil
    end
    if off + 4 > len then
      sub:add_expert_info(PI_MALFORMED, PI_ERROR, name .. " announced but the option is too short")
      return nil
    end
    sub:add(field, o(off, 4))
    off = off + 4
    return off - 4
  end

  optional(EXT_FLOW_ID, f.flow_id, "Flow ID")
  optional(EXT_SEQ_NUM, f.seq_num, "Sequence Number")
  sec_off = optional(EXT_TS_SEC, f.ts_sec, "Timestamp Seconds")
  frac_off = optional(EXT_TS_FRAC, f.ts_frac, "Timestamp Fraction")

  if (sec_off == nil) ~= (frac_off == nil) then
    sub:add_expert_info(PI_PROTOCOL, PI_WARN, "Only one of Timestamp Seconds and Fraction present: no delay can be computed")
    return
  end
  if sec_off == nil then
    return
  end

  local sec = o(sec_off, 4):uint()
  local frac = o(frac_off, 4):uint()
  local limit = dex.prefs.frac_us and 1000000 or 1000000000
  if frac >= limit then
    sub:add_expert_info(PI_PROTOCOL, PI_WARN,
      "Timestamp Fraction out of range for the selected format (see the ioam_dex preferences)")
    return
  end

  local nsec = dex.prefs.frac_us and frac * 1000 or frac
  local stamp = NSTime.new(sec, nsec)
  local span = o(sec_off, 8)
  sub:add(f.encap_time, span, stamp):set_generated()

  -- Only meaningful when the capture clock is the one that stamped the packet.
  -- frame.time_epoch keeps nanosecond precision, pinfo.abs_ts is a double (about 0.2 us resolution).
  local capture = frame_time_field()
  if capture == nil or type(capture.value) ~= "userdata" then
    return
  end
  local delta = capture.value - stamp
  sub:add(f.capture_delta, span, delta):set_generated()
  sub:add(f.capture_delta_us, span, delta.secs * 1e6 + delta.nsecs / 1e3):set_generated()
end

function dex.dissector(tvb, pinfo, tree)
  if not hbh_field then
    return
  end

  for _, fi in ipairs({ hbh_field() }) do
    local r = fi.range
    local n = r:len()
    local pos = 2 -- skip next header and header length

    while pos < n do
      local t = r(pos, 1):uint()
      if t == 0 then
        pos = pos + 1 -- Pad1
      else
        if pos + 2 > n then
          break
        end
        local total = 2 + r(pos + 1, 1):uint()
        if pos + total > n then
          break
        end
        -- Fixed part is 12 octets: type, len, reserved, IOAM type, namespace, flags, ext flags, trace type, reserved
        if DEX_OPT_TYPES[t] and total >= 12 and r(pos + 3, 1):uint() == IOAM_TYPE_DEX then
          dissect_dex(r(pos, total), pinfo, tree)
        end
        pos = pos + total
      end
    end
  end
end

register_postdissector(dex)
