---
sidebar_position: 17
---

# 散射态计算组件

该组件为PWmat Transport工作流类型第三个组件，必须连接在电极能带计算及连接组件之后。

该组件根据电势计算及拼接组件的偏压设置和电极能带计算及连接组件的K点设置。分别计算每个K点在不同偏压时的
辅助微扰函数𝑊<sub>𝑙</sub>(𝑟)、求解(𝐻−𝐸𝑟𝑒𝑓)𝜓<sub>(𝑙)</sub>(𝑟) = 𝑊<sub>𝑙</sub>(𝑟)得到𝜓<sub>(𝑙)</sub>(𝑟)，最后在边界元电极中分解𝜓<sub>(𝑙)</sub>(𝑟)，并计算散射态𝜓<sub>𝑠𝑐</sub>(𝑟)。

该组件生成各K点的透射系数、电流-电压曲线。