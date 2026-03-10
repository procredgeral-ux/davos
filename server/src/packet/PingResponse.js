function PingResponse() {
}

module.exports = PingResponse;

PingResponse.prototype.build = function() {
    var buf = new ArrayBuffer(1);
    var view = new DataView(buf);

    view.setUint8(0, 222, true);

    return buf;
};
