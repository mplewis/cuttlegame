from __future__ import (
    absolute_import, division, print_function, with_statement
)
import re
import os
from flask import (
    Flask,
    request,
    Response,
    jsonify,
    abort,
)
from gevent import subprocess as gsp, spawn, sleep
from geventwebsocket.exceptions import WebSocketError
from .response import httperror
from .util import ignored
from .state import state
from .log import log


# Flask app
app = Flask('novnc2')
app.config.from_object('config.Default')
app.config.from_object(os.environ.get('CONFIG') or 'config.Development')


@app.route('/api/state')
@httperror
def apistate():
    state.wait(int(request.args.get('id', -1)), 30)
    state.switch_video(request.args.get('video', 'false') == 'true')
    mystate = state.to_dict()
    return jsonify({
        'code': 200,
        'data': mystate,
    })


@app.route('/api/health')
def apihealth():
    if state.health:
        return 'success'
    abort(503, 'unhealthy')


@app.route('/api/reset')
def reset():
    if 'w' in request.args and 'h' in request.args:
        args = {
            'w': int(request.args.get('w')),
            'h': int(request.args.get('h')),
        }
        state.set_size(args['w'], args['h'])

    state.apply_and_restart()

    # check all running
    for i in range(40):
        if state.health:
            break
        sleep(1)
        log.info('wait services is ready...')
    else:
        return jsonify({
            'code': 500,
            'errorMessage': 'service is not ready, please restart container'
        })
    return jsonify({'code': 200})


@app.route('/resize')
@httperror
def apiresize():
    state.reset_size()
    return '<html><head><script type = "text/javascript">var h=window.location.href;window.location.href=h.substring(0,h.length-6);</script></head></html>'


if __name__ == '__main__':
    app.run(host=app.config['ADDRESS'], port=app.config['PORT'])
